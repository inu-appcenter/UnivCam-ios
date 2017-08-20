//
//  PhotoDataSource.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 4..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource {
    
    var photos = [UIImage]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "UICollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCell
        let photo = photos[indexPath.row]
        cell.imageView.image = photo
        
        if indexPath.row == 0 {
           cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
     
        
        return cell
    }
}
