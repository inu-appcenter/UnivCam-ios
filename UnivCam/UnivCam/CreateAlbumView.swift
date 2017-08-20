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
    @IBOutlet var albumTitleTextField: UITextField!
    @IBOutlet var createButton: UIButton!
    
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
