//
//  ConfirmDeleteView.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 9..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class ConfirmDeleteView: UIView, NibFileOwnerLoadable {
    
    @IBOutlet weak var mainTitle: UILabel! {
        didSet{
            switch (DeviceUtility.knowDeviceSize()) {
            case 0: mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 24)
                break
            case 1: mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 28)
                break
            case 2: mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 32)
                break
            case 3: mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 35)
                break
            default:
                mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 32)
                break
            }
        }
    }
    
    @IBOutlet var albumTitleLabel: UILabel! {
        didSet{
            switch (DeviceUtility.knowDeviceSize()) {
            case 0: albumTitleLabel.font = UIFont(name: albumTitleLabel.font.fontName, size: 12)
                break
            case 1: albumTitleLabel.font = UIFont(name: albumTitleLabel.font.fontName, size: 14)
                break
            case 2: albumTitleLabel.font = UIFont(name: albumTitleLabel.font.fontName, size: 16)
                break
            case 3: albumTitleLabel.font = UIFont(name: albumTitleLabel.font.fontName, size: 18)
                break
            default:
                albumTitleLabel.font = UIFont(name: albumTitleLabel.font.fontName, size: 16)
                break
            }
        }
    }
    
    @IBOutlet weak var subTitlte1: UILabel! {
        didSet{
            switch (DeviceUtility.knowDeviceSize()) {
            case 0: subTitlte1.font = UIFont(name: subTitlte1.font.fontName, size: 12)
                break
            case 1: subTitlte1.font = UIFont(name: subTitlte1.font.fontName, size: 14)
                break
            case 2: subTitlte1.font = UIFont(name: subTitlte1.font.fontName, size: 16)
                break
            case 3: subTitlte1.font = UIFont(name: subTitlte1.font.fontName, size: 18)
                break
            default:
                subTitlte1.font = UIFont(name: subTitlte1.font.fontName, size: 16)
                break
            }
        }
    }
    
    @IBOutlet weak var subTitle2: UILabel! {
        didSet{
            switch (DeviceUtility.knowDeviceSize()) {
            case 0: subTitle2.font = UIFont(name: subTitle2.font.fontName, size: 12)
                break
            case 1: subTitle2.font = UIFont(name: subTitle2.font.fontName, size: 14)
                break
            case 2: subTitle2.font = UIFont(name: subTitle2.font.fontName, size: 16)
                break
            case 3: subTitle2.font = UIFont(name: subTitle2.font.fontName, size: 18)
                break
            default:
                subTitle2.font = UIFont(name: subTitle2.font.fontName, size: 16)
                break
            }
        }
    }
    
    @IBOutlet var exitButton: UIButton! {
        didSet {
            exitButton.addTarget(self,
                                   action: #selector(remove),
                                   for: .touchUpInside)
            switch (DeviceUtility.knowDeviceSize()) {
            case 0: exitButton.titleLabel?.font = UIFont(name: (exitButton.titleLabel?.font.fontName)!, size: 18)
                break
            case 1: exitButton.titleLabel?.font = UIFont(name: (exitButton.titleLabel?.font.fontName)!, size: 20)
                break
            case 2: exitButton.titleLabel?.font = UIFont(name: (exitButton.titleLabel?.font.fontName)!, size: 26)
                break
            case 3: exitButton.titleLabel?.font = UIFont(name: (exitButton.titleLabel?.font.fontName)!, size: 28)
                break
            default:
                exitButton.titleLabel?.font = UIFont(name: (exitButton.titleLabel?.font.fontName)!, size: 26)
                break
            }
        }
    }
    
    @IBOutlet var cancelButton: UIButton! {
        didSet {
            cancelButton.contentHorizontalAlignment = .left
            cancelButton.addTarget(self,
                                   action: #selector(remove),
                                   for: .touchUpInside)
            switch (DeviceUtility.knowDeviceSize()) {
            case 0: cancelButton.titleLabel?.font = UIFont(name: (cancelButton.titleLabel?.font.fontName)!, size: 18)
                break
            case 1: cancelButton.titleLabel?.font = UIFont(name: (cancelButton.titleLabel?.font.fontName)!, size: 20)
                break
            case 2: cancelButton.titleLabel?.font = UIFont(name: (cancelButton.titleLabel?.font.fontName)!, size: 26)
                break
            case 3: cancelButton.titleLabel?.font = UIFont(name: (cancelButton.titleLabel?.font.fontName)!, size: 28)
                break
            default:
                cancelButton.titleLabel?.font = UIFont(name: (cancelButton.titleLabel?.font.fontName)!, size: 26)
                break
            }
        }
    }
    
    @IBOutlet var deleteButton: UIButton! {
        didSet {
            deleteButton.contentHorizontalAlignment = .left
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }
    func remove() {
        self.removeFromSuperview()
    }
    
}
