//
//  FavoriteAlbumListViewController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit
import Photos

class FavoriteAlbumListVC: UIViewController {
    @IBOutlet var collectionView: UICollectionView!

    let albumDataSource = AlbumDataSource()
    
    override func viewWillAppear(_ animated: Bool) {
//        let photos = PHPhotoLibrary.authorizationStatus()
//        if photos == .notDetermined {
//            PHPhotoLibrary.requestAuthorization({status in
//                if status == .authorized{
//                    print("yes")
//                } else {
//                    print("no")
//                }
//            })
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = albumDataSource
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "AlbumCell", bundle: nil), forCellWithReuseIdentifier: "UICollectionViewCell")
        //albumDataSource.photos = GetServices.photos(type: .big)
        albumDataSource.viewType = "Favorites"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FavoriteAlbumListVC {
    
}


extension FavoriteAlbumListVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        return CGSize(width: 175.5, height: 243)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(27, 8, 27, 8)
    }
}
