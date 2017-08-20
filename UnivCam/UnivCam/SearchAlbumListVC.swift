//
//  SearchPhotoAlbumViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

class SearchAlbumListVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(Cells.album.nib,
                                    forCellWithReuseIdentifier: Cells.album.identifier)
            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(keyboardWillHide)
            )
            collectionView.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.addTarget(self,
                                      action: #selector(searchAlbumsAsPerText(_ :)),
                                      for: .editingChanged)
            switch (DeviceUtility.knowDeviceSize()) {
            case 0: searchTextField.font = UIFont(name: (searchTextField.font?.fontName)!, size: 22)
                break
            case 1: searchTextField.font = UIFont(name: (searchTextField.font?.fontName)!, size: 26)
                break
            case 2: searchTextField.font = UIFont(name: (searchTextField.font?.fontName)!, size: 30)
                break
            case 3: searchTextField.font = UIFont(name: (searchTextField.font?.fontName)!, size: 33)
                break
            default:
                searchTextField.font = UIFont(name: (searchTextField.font?.fontName)!, size: 30)
                break
            }
        }
    }
    
    @IBOutlet var deleteTextButton: UIBarButtonItem! {
        didSet {
            
        }
    }
    @IBOutlet var albumCountLabel: UILabel!
    
    var albums = AppDelegate.getDelegate().albums
    var notificationToken: NotificationToken? = nil
    
    var searchedAlbums = [Album]()
    var isTextFieldTyped = false
    var selectedAlbum : Album?
    
    var searchCountString : String = "" {
        didSet {
//            searchCountString = "\(searchedAlbums.count)개의 앨범"
//            collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        self.extendedLayoutIncludesOpaqueBars = true
//        searchCountString = "\(searchedAlbums.count)개의 앨범"
//        collectionView.reloadData()
//        searchedAlbums.removeAll()
//        searchedAlbums = Array(albums)
//        collectionView.reloadData()
//
        self.searchAlbumsAsPerText(self.searchTextField)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addRealmNotification()
        
    }
    func addRealmNotification() {
        notificationToken = albums.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                break
                // Results are now populated and can be accessed without blocking the UI
                //self?.noMessageView.isHidden = self?.albums.count == 0 ? false : true
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                    collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                    collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                    self?.searchCountString = "\(self?.albums.count) 개의 앨범"
                    self?.collectionView.reloadData()
//                    self?.noMessageView.isHidden = self?.albums.count == 0 ? false : true
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
    
    func keyboardWillHide() {
        self.searchTextField.endEditing(true)
    }
    
    
    func searchAlbumsAsPerText(_ textfield:UITextField) {
//        searchedAlbums.removeAll()
//        if textfield.text?.characters.count != 0 {
//            for album in albums {
//                let range = album.title.lowercased().range(of: textfield.text!, options: .caseInsensitive, range: nil, locale: nil)
//
//                if range != nil {
//                    searchedAlbums.append(album)
//                }
//            }
//        } else {
//            searchedAlbums = Array(albums)
//        }
//
//        searchCountString = "\(searchedAlbums.count) 개의 앨범"
//        collectionView.reloadData()
        
        let predicate = NSPredicate(format: "title contains[c] %@", searchTextField.text!)
        let realm = try! Realm()
        albums = realm.objects(Album.self).filter(predicate)
        searchCountString = "\(albums.count) 개의 앨범"
        collectionView.reloadData()
    }
    
    @IBAction func clearTextField(_ sender: UIBarButtonItem) {
        
        if isTextFieldTyped {
            searchTextField.text?.removeAll()
            searchedAlbums.removeAll()
            searchedAlbums = Array(albums)
            collectionView.reloadData()
        }
    }
    
}

extension SearchAlbumListVC: UICollectionViewDataSource {
    
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
        cell.isFavButtonChecked = album.isFavorite
        cell.favoriteButton.addTarget(
            self,
            action: #selector(toggleFavorite(sender:)),
            for: .touchUpInside
        )
        
        cell.editButton.addTarget(
            self,
            action: #selector(cellIsEditing(sender:)),
            for: .touchUpInside)
        
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

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        switch (DeviceUtility.knowDeviceSize()) {
        case 0:
            return CGSize(width: 148, height: 204.1)
        case 1:
            return CGSize(width: 148, height: 204.1)
        case 2:
            return CGSize(width: 175.5, height: 243)
        case 3:
            return CGSize(width: 195, height: 269)
        default:
            return CGSize(width: 175.5, height: 243)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                                         withReuseIdentifier: "CustomHeaderCell",
                                                                         for: indexPath) as! SearchHeaderCell
        
        headerCell.searchListCountLabel.text = searchCountString
        return headerCell
    }
}


extension SearchAlbumListVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 8, 27, 8)
    }
}

extension SearchAlbumListVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if searchTextField.text?.isEmpty ?? false {
            isTextFieldTyped = false
        } else {
            isTextFieldTyped = true
        }
        
        return true
    }
}

extension SearchAlbumListVC {
    func toggleFavorite(sender: UIButton) {
        let senderPosition = sender.convert(CGPoint.zero, to: self.collectionView)
        guard let indexPath: IndexPath = self.collectionView.indexPathForItem(at: senderPosition) else { return }
        let realm = try! Realm()
        let query = "title = '\(albums[indexPath.row].title)'"
        guard let album = realm.objects(Album.self).filter(query).first else { return }
        do {
            try realm.write {
                album.isFavorite = !album.isFavorite
            }
        } catch {
            print(error)
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

// UPDATE
extension SearchAlbumListVC {
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
}

extension SearchAlbumListVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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


