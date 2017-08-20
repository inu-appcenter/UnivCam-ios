//
//  SearchDeleteViewController.swift
//  UnivCam
//
//  Created by 조용문 on 2017. 8. 12..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class SearchDeleteViewController: UIViewController {
    
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
        subTitle1.font = UIFont(name: subTitle1.font.fontName, size: 13)
        mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 12)
        cancelBttn.titleLabel?.font = UIFont(name: (cancelBttn.titleLabel?.font.fontName)!, size: 18)
        deleteBttn.titleLabel?.font = UIFont(name: (deleteBttn.titleLabel?.font.fontName)!, size: 18)
            break
        case 1: mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 26)
        subTitle1.font = UIFont(name: subTitle1.font.fontName, size: 15)
        subTitle2.font = UIFont(name: subTitle2.font.fontName, size: 14)
        cancelBttn.titleLabel?.font = UIFont(name: (cancelBttn.titleLabel?.font.fontName)!, size: 20)
        deleteBttn.titleLabel?.font = UIFont(name: (deleteBttn.titleLabel?.font.fontName)!, size: 20)
            break
        case 2: mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 30)
        subTitle1.font = UIFont(name: subTitle1.font.fontName, size: 17)
        subTitle2.font = UIFont(name: subTitle2.font.fontName, size: 16)
        cancelBttn.titleLabel?.font = UIFont(name: (cancelBttn.titleLabel?.font.fontName)!, size: 24)
        deleteBttn.titleLabel?.font = UIFont(name: (deleteBttn.titleLabel?.font.fontName)!, size: 24)
            break
        case 3: mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 33)
        subTitle1.font = UIFont(name: subTitle1.font.fontName, size: 19)
        subTitle2.font = UIFont(name: subTitle2.font.fontName, size: 18)
        cancelBttn.titleLabel?.font = UIFont(name: (cancelBttn.titleLabel?.font.fontName)!, size: 26)
        deleteBttn.titleLabel?.font = UIFont(name: (deleteBttn.titleLabel?.font.fontName)!, size: 26)
            break
        default:
            mainTitle.font = UIFont(name: mainTitle.font.fontName, size: 30)
            subTitle1.font = UIFont(name: subTitle1.font.fontName, size: 17)
            subTitle2.font = UIFont(name: subTitle2.font.fontName, size: 16)
            cancelBttn.titleLabel?.font = UIFont(name: (cancelBttn.titleLabel?.font.fontName)!, size: 24)
            deleteBttn.titleLabel?.font = UIFont(name: (deleteBttn.titleLabel?.font.fontName)!, size: 24)
            break
        }
    }
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var subTitle1: UILabel!
    @IBOutlet weak var subTitle2: UILabel!
    @IBOutlet weak var cancelBttn: UIButton!
    @IBOutlet weak var deleteBttn: UIButton!
    @IBOutlet weak var backBttn: UIButton!
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func deleteSearch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

