//
//  FavoriteAlbumListViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteAlbumListVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellWithReuseIdentifier: "UICollectionViewCell")
        }
    }
    
    let albums: Results<Album> = {
        let realm = try! Realm()
        return realm.objects(Album.self).filter("isFavorite == true")
    }()
    var notificationToken: NotificationToken? = nil
    
    var createAlbumView : CreateAlbumView?
    var confirmDeleteView : ConfirmDeleteView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationToken = albums.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                collectionView.reloadData()
                break
                
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                    collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                    collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                }, completion: { _ in })
                break
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
                break
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension FavoriteAlbumListVC {
    func updateFavoriteAlbum(sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.collectionView)
        guard let indexPath: IndexPath = self.collectionView.indexPathForItem(at: buttonPosition) else { return }
        //print(albums[indexPath.row].title)
        
        let oldAlbum = albums[indexPath.row]
        
        let updateAlbum = Album()
        updateAlbum.title = oldAlbum.title
        updateAlbum.id = oldAlbum.id
        updateAlbum.createdAt = oldAlbum.createdAt
        updateAlbum.isFavorite = !oldAlbum.isFavorite
        updateAlbum.createdAt = oldAlbum.createdAt
        updateAlbum.url = oldAlbum.url
        updateAlbum.photoCount = oldAlbum.photoCount
        
        let query = "id == \(updateAlbum.id)"
        RealmHelper.updateObject(data: updateAlbum, query: query)
        
        
    }
    
    
    func cellIsEditing(sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "앨범 선택", style: .default) { action in
            // perhaps use action.title here
        })
        alert.addAction(UIAlertAction(title: "앨범 이름변경", style: .default) { action in
            // perhaps use action.title here
        })
        alert.addAction(UIAlertAction(title: "앨범 삭제", style: .default) { action in
            // perhaps use action.title here
            
            let buttonPosition = sender.convert(CGPoint.zero, to: self.collectionView)
            guard let indexPath: IndexPath = self.collectionView.indexPathForItem(at: buttonPosition) else { return }
            
            self.confirmDeleteView = ConfirmDeleteView(frame: (UIApplication.shared.keyWindow?.frame)!)
            
            self.confirmDeleteView?.cancelButton.addTarget(
                self,
                action: #selector(self.removeDeleteView),
                for: .touchUpInside
            )
            self.confirmDeleteView?.deleteButton.tag = indexPath.row
            self.confirmDeleteView?.deleteButton.addTarget(
                self,
                action: #selector(self.removeAlbum(sender:)),
                for: .touchUpInside
            )
            UIApplication.shared.keyWindow?.addSubview(self.confirmDeleteView!)
            self.confirmDeleteView?.frame.origin.y = 20
            
            
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
    func removeCreateView() {
        createAlbumView?.removeFromSuperview()
    }
    func createAlbumFolder(title: String) {
        let createdAt = NSDate()
        let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let documentDirecortPath = mainPath + "/UnivCam" + "/\(title)"
        
        var ojeCtBool : ObjCBool = true
        let isExit = FileManager.default.fileExists(atPath: documentDirecortPath, isDirectory: &ojeCtBool)
        print(isExit)
        print(documentDirecortPath)
        if isExit == false {
            do {
                try FileManager.default.createDirectory(at: URL(fileURLWithPath: documentDirecortPath), withIntermediateDirectories: true, attributes: nil)
                
                let album = Album()
                album.title = title
                album.url = UnivCamAPI.baseURL() + "/" + title
                album.id = Album.incrementID()
                
                guard let files = try! FileManager.default.contentsOfDirectory(atPath: album.url) as? [String] else {
                    return
                }
                album.photoCount = files.count
                
                
                RealmHelper.addData(data: album)
                //albums.removeAll()
                //RealmHelper.fetchData(dataList: &albums)
                //collectionView.reloadData()
                
            } catch {
                print("error")
            }
        } else {
            print("fail")
        }
    }
    
    func createAlbum() {
        guard let albumTitle = createAlbumView?.albumTitleTextField.text, !(createAlbumView?.albumTitleTextField.text?.characters.isEmpty)! else {
            return
        }
        createAlbumFolder(title: albumTitle)
        removeCreateView()
    }
    func removeDeleteView() {
        confirmDeleteView?.removeFromSuperview()
    }
    func removeAlbum(sender: UIButton) {
        print("호출?")
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let album = self.albums[indexPath.row]
        RealmHelper.removeData(data: album)
        //self.albums.remove(at: indexPath.row)
        //self.collectionView.deleteItems(at: [indexPath])
        removeDeleteView()
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
        cell.imageView.image = UIImage(named: "back")
        cell.titleLabel.text = album.title
        cell.favoriteButton.isHidden = true
        
        cell.favoriteButton.addTarget(
            self,
            action: #selector(updateFavoriteAlbum(sender:)),
            for: .touchUpInside
        )
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(
            self,
            action: #selector(cellIsEditing(sender:)),
            for: .touchUpInside
        )
        cell.pictureCountLabel.text = String(album.photoCount) + "장의 사진"
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        return cell
    }
    
}

extension FavoriteAlbumListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowDetailAlbum", sender: self)
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
