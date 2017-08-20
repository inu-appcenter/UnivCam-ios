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
    
    @IBOutlet var exitButton: UIButton! {
        didSet {
            exitButton.addTarget(self,
                                   action: #selector(remove),
                                   for: .touchUpInside)
        }
    }
    
    @IBOutlet var cancelButton: UIButton! {
        didSet {
            cancelButton.contentHorizontalAlignment = .left
            cancelButton.addTarget(self,
                                   action: #selector(remove),
                                   for: .touchUpInside)
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
