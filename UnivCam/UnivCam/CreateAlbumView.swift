//
//  CreateAlbumView.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 10..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class CreateAlbumView: UIView {

    let nibName = "CreateAlbumView"
    var view : UIView!
    
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var albumTitleTextField: UITextField!
    @IBOutlet var createButton: UIButton!
    
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
