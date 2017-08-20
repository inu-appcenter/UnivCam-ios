//
//  OpenSourceViewController.swift
//  UnivCam
//
//  Created by 조용문 on 2017. 8. 17..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class OpenSourceViewController: UIViewController {
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var mainTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        switch (DeviceUtility.knowDeviceSize()) {
        case 0: mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 22)
        mainTextField.font = UIFont(name: (mainTextField.font?.fontName)!, size: 11)
            break
        case 1: mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 26)
        mainTextField.font = UIFont(name: (mainTextField.font?.fontName)!, size: 13)
            break
        case 2: mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 30)
        mainTextField.font = UIFont(name: (mainTextField.font?.fontName)!, size: 15)
            break
        case 3: mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 33)
        mainTextField.font = UIFont(name: (mainTextField.font?.fontName)!, size: 17)
            break
        default:
            mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 30)
            mainTextField.font = UIFont(name: (mainTextField.font?.fontName)!, size: 15)
            break
        }
    }
}

