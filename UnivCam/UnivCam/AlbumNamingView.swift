//
//  AlbumNamingView.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 16..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class AlbumNamingView: UIView, NibFileOwnerLoadable {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var cancelButton: UIButton! {
        didSet {
            cancelButton.addTarget(self,
                                   action: #selector(initView),
                                   for: .touchUpInside)
        }
    }
    @IBOutlet var inputTextField: UITextField!
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


