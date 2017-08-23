//
//  PhotoCell.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 4..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell, UIScrollViewDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var checkedImage: UIImageView! {
        didSet{
            checkedImage.isHidden = true
        }
    }
    @IBOutlet weak var translucentView: UIView!
    var is_selected : Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //scrollView.delegate = self
       
        //self.scrollView.minimumZoomScale = 1.0
        //self.scrollView.maximumZoomScale = 6.0
    }
}
