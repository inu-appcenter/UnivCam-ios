//
//  AVC.swift
//  UnivCam
//
//  Created by 조용문 on 2017. 9. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

// A -> B로 보낼 때

class AVC: UIViewController {
    
    var delgate:ViewCallback?
    
    override func viewDidLoad() {
        self.delgate?.passData(data: "Hello World", code: "go_home")
        
    }
}

class BVC: UIViewController, ViewCallback {
    
    override func viewDidLoad() {
//        let AVC = AVC()
//        AVC.delegate = self
    }
    
    func passData(data: Any, code: String) {
        if code == "go_home" {
//            sdafsadf
        }
        
        if code == "hello" {
//            asdjfsflk
        }
    }
}

protocol ViewCallback {
    func passData(data: Any, code:String)
}
