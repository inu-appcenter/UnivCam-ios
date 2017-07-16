//
//  HomeAlbumListViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class HomeAlbumListViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    let photoDataSource = PhotoDataSource()
    var titleLabel : UILabel?
    var isScrollGreaterThanSpace = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        photoDataSource.photos = GetServices.photos(type: .big)
        GetServices.albums()
//        GetServices.getAlbumWithName(named: "Test")
//        
        
        
//        let gesture = UITapGestureRecognizer(
//            target: self,
//            action: #selector(cellImageViewDidTap)
//        )
//        collectionView.cellForItem(at: IndexPath(row: 0, section: 0))?.addGestureRecognizer(gesture)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 117.5, height: view.frame.height))
        titleLabel?.text = "앨범"
        titleLabel?.textColor = UIColor.init(hex: 0x353946)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        navigationItem.titleView = titleLabel
        titleLabel?.isHidden = true
        
        
        
//        let createFolderButton = UIBarButtonItem(image: UIImage(named:"icCreateNewFolder2X"),  style: .plain, target: self, action: nil)
//        let sortListButton = UIBarButtonItem(image: UIImage(named:"icSort2X"),  style: .plain, target: self, action: nil)
//        
//        navigationItem.rightBarButtonItems = [createFolderButton, sortListButton]

    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print(scrollView.contentOffset.y)
        if scrollView.contentOffset.y > -27 && !isScrollGreaterThanSpace {
            titleLabel?.isHidden = false
            isScrollGreaterThanSpace = true
            self.titleLabel?.slideInFromTop()
        }
        else if scrollView.contentOffset.y < -27 && isScrollGreaterThanSpace {
            isScrollGreaterThanSpace = false
            titleLabel?.isHidden = true
        }
        
    }
    
    public func cellImageViewDidTap() {
        print("yes")
        self.performSegue(withIdentifier: "pushToAlbum", sender: self)
    }
    
}

extension HomeAlbumListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 175.5, height: 243)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(27, 8, 27, 8)
    }
}

extension HomeAlbumListViewController : UICollectionViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("s")
//    }
}


class PhotoDataSource: NSObject, UICollectionViewDataSource {
    
    var photos = [UIImage]()
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "UICollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCollectionViewCell
        let photo = photos[indexPath.row]
        cell.imageView.image = photo
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CustomHeaderCell", for: indexPath as IndexPath)
        return headerView
    }
}
