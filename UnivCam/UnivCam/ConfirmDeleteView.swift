//
//  ConfirmDeleteView.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 9..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class ConfirmDeleteView: UIView, NibFileOwnerLoadable {
    
    @IBOutlet var albumTitleLabel: UILabel!
    @IBOutlet var cancelButton: UIButton! {
        didSet {
            cancelButton.contentHorizontalAlignment = .left
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
    
}
