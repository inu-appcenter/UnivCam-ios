//
//  NoMessageView.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 16..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class NoMessageView: UIView, NibFileOwnerLoadable {
    
    @IBOutlet var messageLabel: UILabel! {
        didSet{
            switch (DeviceUtility.knowDeviceSize()) {
            case 0: messageLabel.font = UIFont(name: messageLabel.font.fontName, size: 12)
                break
            case 1: messageLabel.font = UIFont(name: messageLabel.font.fontName, size: 14)
                break
            case 2: messageLabel.font = UIFont(name: messageLabel.font.fontName, size: 16)
                break
            case 3: messageLabel.font = UIFont(name: messageLabel.font.fontName, size: 18)
                break
            default:
                messageLabel.font = UIFont(name: messageLabel.font.fontName, size: 16)
                break
            }
        }
    }
    @IBOutlet var actionButton: UIButton!
        {
        didSet{
            guard (actionButton.titleLabel?.font.fontName)! != nil else {return}
            switch (DeviceUtility.knowDeviceSize()) {
            case 0: actionButton.titleLabel?.font = UIFont(name: (actionButton.titleLabel?.font.fontName)!, size: 20)
                break
            case 1: actionButton.titleLabel?.font = UIFont(name: (actionButton.titleLabel?.font.fontName)!, size: 22)
                break
            case 2: actionButton.titleLabel?.font = UIFont(name: (actionButton.titleLabel?.font.fontName)!, size: 26)
                break
            case 3: actionButton.titleLabel?.font = UIFont(name: (actionButton.titleLabel?.font.fontName)!, size: 28)
                break
            default:
                actionButton.titleLabel?.font = UIFont(name: (actionButton.titleLabel?.font.fontName)!, size: 26)
                break
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
    }
}
