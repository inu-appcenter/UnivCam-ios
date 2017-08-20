//
//  FavoriteAlbumListViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

class FavoriteAlbumListVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(Cells.album.nib, forCellWithReuseIdentifier: Cells.album.identifier)
        }
    }
    @IBOutlet var noMessageView: NoMessageView! {
        didSet {
            noMessageView.messageLabel.text = Messages.has_no_favorite_albums.rawValue
            noMessageView.actionButton.isHidden = true
        }
    }
    let albums: Results<Album> = {
        let realm = try! Realm()
        return realm.objects(Album.self).filter("isFavorite == true")
    }()
    
    var selectedAlbum : Album?
    var notificationToken: NotificationToken? = nil
    
    var createAlbumView : CreateAlbumView?
    var confirmDeleteView : ConfirmDeleteView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("값나왔냐", albums.count)
        // Do any additional setup after loading the view.
        self.addRealmNotification()
    }
    
    func addRealmNotification() {
        notificationToken = albums.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self?.noMessageView.isHidden = self?.albums.count == 0 ? false : true
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                    collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                    collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                    
                    self?.collectionView.reloadData()
                    self?.noMessageView.isHidden = self?.albums.count == 0 ? false : true
                }, completion: { _ in })
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension FavoriteAlbumListVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "UICollectionViewCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! AlbumCell
        let album = albums[indexPath.row]
        cell.titleLabel.text = album.title
        cell.favoriteButton.isHidden = true
        cell.editButton.addTarget(
            self,
            action: #selector(cellIsEditing(sender:)),
            for: .touchUpInside
        )
        cell.pictureCountLabel.text = String(album.photoCount) + "장의 사진"
        cell.cameraButton.addTarget(
            self,
            action: #selector(showCamera(sender:)),
            for: .touchUpInside
        )
        
        if let coverImageData = album.coverImageData {
            cell.imageView.image = UIImage(data: coverImageData as Data)
            return cell
        }
        if let coverImageURL = album.photos.last?.url {
            cell.imageView.image = UIImage(named: coverImageURL)
        }
        
        return cell
    }
    
}

extension FavoriteAlbumListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                                         withReuseIdentifier: "CustomHeaderCell",
                                                                         for: indexPath)
        return headerView
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 175.5, height: 243)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(27, 8, 27, 8)
    }
}

extension FavoriteAlbumListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = ViewControllers.album_detail.instance as? AlbumDetailVC else { return }
        vc.album = self.albums[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// DELETE
extension FavoriteAlbumListVC {
    func removeAlbum(sender: UIButton) {
        print("test")
        
        let album = self.albums[sender.tag]
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: album.url)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
        RealmHelper.removeData(data: album)
        confirmDeleteView?.remove()
    }
}

// UPDATE
extension FavoriteAlbumListVC {
    func showCamera(sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.collectionView)
        guard let indexPath: IndexPath = self.collectionView.indexPathForItem(at: buttonPosition) else { return }
        
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) {
            (granted: Bool) -> Void in
            guard granted else {
                /// Report an error. We didn't get access to hardware.
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tabBarController?.selectedIndex = TapViewControllers.camera.rawValue
                })
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let vc = UIStoryboard.init(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: "CustomCameraVC") as! CustomCameraVC
                vc.cameraType = .select
                vc.album = Array(self.albums)[indexPath.row]
                self.present(
                    vc,
                    animated: true,
                    completion: nil
                )
            })
        }
    }
    func cellIsEditing(sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.collectionView)
        guard let indexPath: IndexPath = self.collectionView.indexPathForItem(at: buttonPosition) else { return }
        let album = self.albums[indexPath.row]
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if albums[indexPath.row].coverImageData != nil {
            alert.addAction(UIAlertAction(title: "앨범 커버 사진 삭제", style: .default) { action in
                
                let realm = try! Realm()
                do {
                    try realm.write {
                        album.coverImageData = nil
                    }
                } catch {
                    print(error)
                    print("에러났다 왜냐")
                }
                let cell = self.collectionView.cellForItem(at: indexPath) as? AlbumCell
                cell?.imageView.image = nil
                self.collectionView.reloadData()
            })
        } else {
            alert.addAction(UIAlertAction(title: "앨범 커버 사진 선택", style: .default) { action in
                self.addCoverImage()
                self.selectedAlbum = self.albums[indexPath.row]
            })
        }
        alert.addAction(UIAlertAction(title: "앨범 이름변경", style: .default) { action in
            
            let nvc = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "AlbumNameEditingVC") as! AlbumNameEditingVC
            nvc.album = album
            self.navigationController?.pushViewController(nvc, animated: true)
            
            
        })
        alert.addAction(UIAlertAction(title: "앨범 삭제", style: .default) { action in
            // perhaps use action.title here
            
            self.confirmDeleteView = ConfirmDeleteView(frame: (UIApplication.shared.keyWindow?.frame)!)
            self.confirmDeleteView?.frame.origin.y = UIApplication.shared.statusBarFrame.height
            
            self.confirmDeleteView?.deleteButton.tag = indexPath.row
            self.confirmDeleteView?.deleteButton.addTarget(
                self,
                action: #selector(self.removeAlbum(sender:)),
                for: .touchUpInside
            )
            self.confirmDeleteView?.albumTitleLabel.text = self.albums[indexPath.row].title
            
            UIApplication.shared.keyWindow?.addSubview(self.confirmDeleteView!)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel) { action in
            
        })
        
        self.present(
            alert,
            animated: true,
            completion: { () in
                // add view tapped evnets
        })
    }
}

extension FavoriteAlbumListVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func addCoverImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(
            imagePicker,
            animated: true,
            completion: nil
        )
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        let data = NSData(data: UIImagePNGRepresentation(image)!)
        
        let realm = try! Realm()
        do {
            try realm.write {
                self.selectedAlbum?.coverImageData = data
            }
        } catch {
            print(error)
        }
        self.selectedAlbum = nil
        
        picker.dismiss(
            animated: true,
            completion: nil
        )
    }
}
