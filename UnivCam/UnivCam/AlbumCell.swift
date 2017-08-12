//
//  AlbumCell.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 4..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

protocol Editable {
    func cellIsEditing()
}

class AlbumCell: UICollectionViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var pictureCountLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var photoCountLabel: UILabel!
    
    @IBOutlet var checkImage: UIImageView!
    
    var isFavButtonChecked = false {
        didSet {
            if isFavButtonChecked == true {
                favoriteButton.setImage(UIImage(named: "icStar"), for: .normal)
            } else {
                favoriteButton.setImage(UIImage(named: "icStarBorderWhite"), for: .normal)
            }
        }
    }
    var delegate: Editable?
    
    @IBAction func favButtonDidTap(_ sender: UIButton) {
//        if isFavButtonChecked {
//            favoriteButton.setImage(UIImage(named: "icStarBorderWhite"), for: .normal)
//        } else {
//            favoriteButton.setImage(UIImage(named: "icStar"), for: .normal)
//        }
        isFavButtonChecked = !isFavButtonChecked
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
