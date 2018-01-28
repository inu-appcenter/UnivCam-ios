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
    @IBOutlet var imageView: UIImageView! {
        didSet {
            imageView.clipsToBounds = true
            imageView.image = nil
            imageView.layer.borderColor = UIColor.lightGray.cgColor
            imageView.layer.borderWidth = 0.5
            self.layer.borderWidth = 0.5
            self.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet var favoriteButton: UIButton! {
        didSet {
            favoriteButton.layer.shadowColor = UIColor.black.cgColor
            favoriteButton.layer.shadowOpacity = 0.5
            favoriteButton.layer.shadowOffset = .zero
            
        }
    }
    @IBOutlet var editButton: UIButton! {
        didSet {
            editButton.layer.shadowColor = UIColor.black.cgColor
            editButton.layer.shadowOpacity = 1
            editButton.layer.shadowOffset = .zero
        }
    }
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var photoCountLabel: UILabel!
    @IBOutlet var checkImage: UIImageView!
    
    var isFavButtonChecked = false {
        didSet {
            if isFavButtonChecked == true {
                favoriteButton.setImage(Assets.favoriteOn.image,
                                        for: .normal)
            } else {
                favoriteButton.setImage(Assets.favoriteOff.image,
                                        for: .normal)
            }
        }
    }
    var delegate: Editable?
    
    @IBAction func favButtonDidTap(_ sender: UIButton) {
        isFavButtonChecked = !isFavButtonChecked
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
