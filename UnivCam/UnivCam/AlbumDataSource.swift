//
//  AlbumDataSource.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 4..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class AlbumDataSource: NSObject, UICollectionViewDataSource {
    
    var albums = [Album]()
    var viewType = ""
    var delegate : Editable?
    
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
        cell.imageView.image = UIImage(named: "back")
        cell.favoriteButton.isHidden = (viewType == "Favorites")
        cell.editButton.addTarget(self, action: #selector(test(sender:)), for: .touchUpInside)
        cell.editButton.tag = indexPath.row
        
        return cell
    }
    
    func test(sender: UIButton) {
        print(sender.tag)
        delegate?.cellIsEditing()
    }
    //    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    //        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CustomHeaderCell", for: indexPath as IndexPath)
    //        return headerView
    //    }
}
