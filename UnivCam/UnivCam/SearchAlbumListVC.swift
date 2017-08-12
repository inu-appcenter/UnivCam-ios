//
//  SearchPhotoAlbumViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit
import RealmSwift

class SearchAlbumListVC: UIViewController {
     
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellWithReuseIdentifier: "UICollectionViewCell")
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
            searchTextField.addTarget(
                self,
                action: #selector(searchAlbumsAsPerText(_ :)),
                for: .editingChanged
            )
        }
    }
    
    @IBOutlet var deleteTextButton: UIBarButtonItem! {
        didSet {
            
        }
    }
    
    var albums = AppDelegate.getDelegate().albums
    var notificationToken: NotificationToken? = nil
    
    var searchedAlbums = [Album]()
    var isTextFieldTyped = false
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.extendedLayoutIncludesOpaqueBars = true
//        albums.removeAll()
        searchedAlbums.removeAll()
        //RealmHelper.fetchData(dataList: &albums)
        searchedAlbums = Array(albums)
        collectionView.reloadData()
    }
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
//                collectionView.performBatchUpdates({
//                    collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
//                    collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
//                    collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
//                }, completion: { _ in })
                self?.searchedAlbums.removeAll()
                self?.searchedAlbums = Array(self!.albums)
                self?.collectionView.reloadData()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        //keyboardWillHide()
        super.viewWillDisappear(true)
    }
    
    func keyboardWillHide() {
        self.searchTextField.endEditing(true)
    }

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowPhoto" {
            
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
//                let photo = photoDataSource.photos[selectedIndexPath.row]
//                
//                let destinationVC = segue.destination as! PhotoVC
//                destinationVC.photos = photoDataSource.photos
                
            }
        }
    }
    
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
    
    
    func searchAlbumsAsPerText(_ textfield:UITextField) {
        searchedAlbums.removeAll()
        if textfield.text?.characters.count != 0 {
            for album in albums {
                let range = album.title.lowercased().range(of: textfield.text!, options: .caseInsensitive, range: nil, locale: nil)
                
                if range != nil {
                    searchedAlbums.append(album)
                }
            }
        } else {
            searchedAlbums = Array(albums)
        }
        
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
        return searchedAlbums.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "UICollectionViewCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! AlbumCell
        let album = searchedAlbums[indexPath.row]
        cell.imageView.image = UIImage(named: "back")
        cell.titleLabel.text = album.title
        cell.isFavButtonChecked = album.isFavorite
        cell.favoriteButton.addTarget(
            self,
            action: #selector(updateFavoriteAlbum(sender:)),
            for: .touchUpInside
        )
        
        //        cell.favToggleButton.isHidden = (viewType == "Favorites")
        cell.editButton.tag = indexPath.row
        cell.pictureCountLabel.text = String(album.photoCount) + "장의 사진"
        //cell.editButton.addTarget(self, action: #selector(cellIsEditing(sender:)), for: .touchUpInside)
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        return cell
    }
    
}


extension SearchAlbumListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 175.5, height: 243)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(27, 8, 27, 8)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 3
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 3
//    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                                         withReuseIdentifier: "CustomHeaderCell",
                                                                         for: indexPath)
        return headerView
    }
}
extension SearchAlbumListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowPhoto", sender: self)
        
    }
}

extension SearchAlbumListVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        isTextFieldTyped = (searchTextField.text?.characters.count)! > 0 ? true : false
        print(isTextFieldTyped)
        
        
        return true
    }
}

extension SearchAlbumListVC {
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print(touches)
//
//        var touch: UITouch? = touches.first
//        guard touch?.view != searchTextField else {
//
//            return
//        }
//
//    }
}


