//
//  AlbumNamingView.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 16..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class AlbumNamingView: UIView, NibFileOwnerLoadable {
    @IBOutlet var titleLabel: UILabel! {
        didSet{
            switch (DeviceUtility.knowDeviceSize()) {
            case 0: titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 24)
                break
            case 1: titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 28)
                break
            case 2: titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 32)
                break
            case 3: titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 35)
                break
            default:
                titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 32)
                break
            }
        }
    }
    @IBOutlet var cancelButton: UIButton! {
        didSet {
            cancelButton.addTarget(self,
                                   action: #selector(initView),
                                   for: .touchUpInside)
        }
    }
    @IBOutlet var inputTextField: UITextField!
        {
        didSet{
            switch (DeviceUtility.knowDeviceSize()) {
            case 0: inputTextField.font = UIFont(name: (inputTextField.font?.fontName)!, size: 12)
                break
            case 1: inputTextField.font = UIFont(name: (inputTextField.font?.fontName)!, size: 14)
                break
            case 2: inputTextField.font = UIFont(name: (inputTextField.font?.fontName)!, size: 16)
                break
            case 3: inputTextField.font = UIFont(name: (inputTextField.font?.fontName)!, size: 18)
                break
            default:
                inputTextField.font = UIFont(name: (inputTextField.font?.fontName)!, size: 16)
                break
            }
        }
    }
    @IBOutlet var doneButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        initView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
        initView()
    }
    func initView() {
        titleLabel.becomeFirstResponder()
    }
    
}
protocol AlbumNamingViewEditable {
    func setTitle(title: String)
    func closeView()
}
extension AlbumNamingViewEditable where Self: AlbumNamingView {
    // set title label
    func setTitle(title: String) {
        titleLabel.text = title
    }
    func closeView() {
        
    }
    
    
}


