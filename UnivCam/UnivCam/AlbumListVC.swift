//
//  AlbumListViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class AlbumListVC: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            navigationItem.titleView = titleLabel
            collectionView.dataSource = albumDataSource
            collectionView.delegate = self
            collectionView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellWithReuseIdentifier: "UICollectionViewCell")
        }
    }
    
    lazy var titleLabel : UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "앨범"
        titleLabel.textColor = UIColor.init(hex: 0x353946)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        return titleLabel
    }()
    
    let albumDataSource = AlbumDataSource()
    
    var isScrollGreaterThanSpace = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        albumDataSource.photos = GetServices.photos(type: .big)
        GetServices.albums()
        
        //        GetServices.getAlbumWithName(named: "Test")
        //
        
        
        //        let gesture = UITapGestureRecognizer(
        //            target: self,
        //            action: #selector(cellImageViewDidTap)
        //        )
        //        collectionView.cellForItem(at: IndexPath(row: 0, section: 0))?.addGestureRecognizer(gesture)
        
        
        //titleLabel?.isHidden = true
        
        
        
        //        let createFolderButton = UIBarButtonItem(image: UIImage(named:"icCreateNewFolder2X"),  style: .plain, target: self, action: nil)
        //        let sortListButton = UIBarButtonItem(image: UIImage(named:"icSort2X"),  style: .plain, target: self, action: nil)
        //
        //        navigationItem.rightBarButtonItems = [createFolderButton, sortListButton]
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //        print(scrollView.contentOffset.y)
        //        if scrollView.contentOffset.y > -27 && !isScrollGreaterThanSpace {
        //            titleLabel?.isHidden = false
        //            isScrollGreaterThanSpace = true
        //            self.titleLabel?.slideInFromTop()
        //        }
        //        else if scrollView.contentOffset.y < -27 && isScrollGreaterThanSpace {
        //            isScrollGreaterThanSpace = false
        //            titleLabel?.isHidden = true
        //        }
        
    }
    
    public func cellImageViewDidTap() {
        print("yes")
        //self.performSegue(withIdentifier: "ShowAlbumDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailAlbum" {
            
        }
    }
}

extension AlbumListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 175.5, height: 243)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(27, 8, 27, 8)
    }
}
extension AlbumListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowAlbumDetail", sender: self)
    }
}
