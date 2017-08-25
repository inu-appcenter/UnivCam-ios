//
//  CreateAlbumView.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 10..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class CreateAlbumView: UIView, NibFileOwnerLoadable {

    
    @IBOutlet var cancelButton: UIButton! {
        didSet {
            cancelButton.addTarget(self,
                                   action: #selector(remove),
                                   for: .touchUpInside)
        }
    }
    @IBOutlet weak var title: UILabel! {
        didSet{
            switch (DeviceUtility.knowDeviceSize()) {
            case 0: title.font = UIFont(name: title.font.fontName, size: 24)
                break
            case 1: title.font = UIFont(name: title.font.fontName, size: 28)
                break
            case 2: title.font = UIFont(name: title.font.fontName, size: 32)
                break
            case 3: title.font = UIFont(name: title.font.fontName, size: 35)
                break
            default:
                title.font = UIFont(name: title.font.fontName, size: 32)
                break
            }
        }
    }
    @IBOutlet var albumTitleTextField: UITextField! {
        didSet{
            switch (DeviceUtility.knowDeviceSize()) {
            case 0: albumTitleTextField.font = UIFont(name: (albumTitleTextField.font?.fontName)!, size: 12)
                break
            case 1: albumTitleTextField.font = UIFont(name: (albumTitleTextField.font?.fontName)!, size: 14)
                break
            case 2: albumTitleTextField.font = UIFont(name: (albumTitleTextField.font?.fontName)!, size: 16)
                break
            case 3: albumTitleTextField.font = UIFont(name: (albumTitleTextField.font?.fontName)!, size: 18)
                break
            default:
                albumTitleTextField.font = UIFont(name: (albumTitleTextField.font?.fontName)!, size: 16)
                break
            }
        }
    }
    @IBOutlet var createButton: UIButton!
    
    @IBOutlet weak var sameNameWarning: UILabel! {
        didSet{
            switch (DeviceUtility.knowDeviceSize()) {
            case 0: sameNameWarning.font = UIFont(name: sameNameWarning.font.fontName, size: 10)
                break
            case 1: sameNameWarning.font = UIFont(name: sameNameWarning.font.fontName, size: 12)
                break
            case 2: sameNameWarning.font = UIFont(name: sameNameWarning.font.fontName, size: 14)
                break
            case 3: sameNameWarning.font = UIFont(name: sameNameWarning.font.fontName, size: 16)
                break
            default:
                sameNameWarning.font = UIFont(name: sameNameWarning.font.fontName, size: 14)
                break
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        albumTitleTextField.becomeFirstResponder()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        albumTitleTextField.becomeFirstResponder()
    }
    func remove() {
        self.removeFromSuperview()
    }
}
extension CreateAlbumView {
    
}
