//
//  AlbumViewCell.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 25..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class AlbumDetailViewCell: UICollectionViewCell {

    var button: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContents()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupContents()
    }
    func setupContents() {
        //self.backgroundColor =
        //imageView = UIImageView(image: UIImage(named: "icStar"))
        //imageView.frame = self.frame
        //imageView.contentMode = .scaleToFill
        //imageView?.backgroundColor = UIColor.lightGray
        //imageView?.image = UIImage.init(named: "splash")
        //addSubview(imageView)
        
//        button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 21))
//        button?.titleLabel?.text = "버튼"
//        button?.backgroundColor = UIColor.red
//        addSubview(button!)
    }
}
