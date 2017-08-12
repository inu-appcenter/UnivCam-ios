//
//  TabbarController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 15..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import AVFoundation
import UIKit

class TabbarController: UITabBarController, UITabBarControllerDelegate {
    
    lazy var button : UIButton = {
        var btn : UIButton = .init(type: .custom)
        btn.setImage(
            UIImage(named:"icCamera"),
            for: .normal
        )
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.yellow, for: .highlighted)
        btn.backgroundColor = UIColor(white: 1, alpha: 0.1)
        btn.addTarget(
            self,
            action: #selector(showCameraVC), for: .touchUpInside
        )
        return btn
    }()
    
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.insertSubview(button, aboveSubview: self.tabBar)
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // safe place to set the frame of button manually
        button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 49, width: 64, height: 50)
        self.tabBar.tintColor = UIColor(hex: 0x353946)
        self.tabBar.unselectedItemTintColor = UIColor(hex: 0xBABAC0)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showCameraVC() {
        
        
        let captureSession = AVCaptureSession()
        
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) {
            (granted: Bool) -> Void in
            guard granted else {
                /// Report an error. We didn't get access to hardware.
                DispatchQueue.main.async(execute: { () -> Void in
                    self.selectedIndex = 2
                })
                print("에러")
                return
            }
            
            // access granted
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomCameraNVC")
                //as! CustomCameraVC
            
            self.present(
                vc,
                animated: true,
                completion: nil
            )
            
        }
    }
    func switchView() {
//        let controllerIndex: Int = 4
//        let tabBarController: UITabBarController? = self.tabBarController
//        let fromView: UIView? = tabBarController?.selectedViewController?.view
//        let toView = tabBarController?.viewControllers?[controllerIndex] as? UIView
//        // Transition using a page curl.
//        UIView.transition(from: fromView!, to: toView!, duration: 0.5, options: (controllerIndex > (tabBarController?.selectedIndex)! ? .transitionCurlUp : .transitionCurlDown), completion: {(_ finished: Bool) -> Void in
//            if finished {
//                tabBarController?.selectedIndex = controllerIndex
//            }
//        })
        //self.selectedIndex = 1
    }
    
    
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.selectedIndex = 1
        print("Selected item")
        print(item.description)
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        print(viewController)
        
        //        if viewController == CameraViewController() {
        //            // Present image picker
        //            print("yes")
        //        }
    }
    
    
}
