//
//  AlbumDataSource.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 4..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class AlbumDataSource: NSObject, UICollectionViewDataSource {
    
    var photos = [UIImage]()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "UICollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! AlbumCell
        let photo = photos[indexPath.row]
        cell.imageView.image = photo
        
        return cell
    }
    //    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    //        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CustomHeaderCell", for: indexPath as IndexPath)
    //        return headerView
    //    }
}
