//
//  NoMessageView.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 16..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class NoMessageView: UIView, NibFileOwnerLoadable {
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var actionButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
    }
}
