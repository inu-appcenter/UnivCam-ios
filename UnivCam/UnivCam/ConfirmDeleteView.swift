//
//  ConfirmDeleteView.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 9..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class ConfirmDeleteView: UIView {
    
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
    
    let nibName = "ConfirmDeleteView"
    var view : UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
    }
    func loadViewFromNib() ->UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    func xibSetUp() {
        view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
}
