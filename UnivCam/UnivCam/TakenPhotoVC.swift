//
//  CapturedImageVC.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 10..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class TakenPhotoVC: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    
    var capturedImage : UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        imageView.image = capturedImage
        UIApplication.shared.isStatusBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let heightForStackView : CGFloat
        switch (DeviceUtility.knowDeviceSize()) {
        case 0:
            heightForStackView = 106
            break
        case 1:
            heightForStackView = 125
            break
        case 2:
            heightForStackView = 147
            break
        case 3:
            heightForStackView = 162
            break
        default:
            heightForStackView = 147
            break
        }
        stackView.frame = CGRect(x: 0, y: (self.view.frame.height - heightForStackView), width: self.view.frame.width, height: heightForStackView)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func unwindToCameraVC(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func showSelectAlbumVC(_ sender: UIButton) {
        guard let nvc = ViewControllers.select_album.instance as? SelectAlbumVC else { return }
       nvc.capturedImage = self.capturedImage
        self.navigationController?.pushViewController(nvc, animated: false)
    }
    override var prefersStatusBarHidden: Bool {
        return true
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
