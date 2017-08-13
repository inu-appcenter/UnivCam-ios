//
//  TabbarController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 15..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import AVFoundation
import UIKit

class TabbarController: UITabBarController {
    
    lazy var button : UIButton = {
        var btn : UIButton = .init(type: .custom)
        btn.setImage(
            Assets.camera.image,
            for: .normal
        )
        btn.backgroundColor = UIColor.clear
        btn.addTarget(
            self,
            action: #selector(showCameraVC), for: .touchUpInside
        )
        btn.frame = .init(
            x: self.tabBar.center.x - 32,
            y: self.view.bounds.height - 49,
            width: 64,
            height: 50
        )
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 탭바에 커스텀 카메라 버튼
        self.tabBar.tintColor = Palette.tabbar.color
        self.view.insertSubview(button, aboveSubview: self.tabBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showCameraVC() {
        
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) {
            (granted: Bool) -> Void in
            guard granted else {
                /// Report an error. We didn't get access to hardware.
                DispatchQueue.main.async(execute: { () -> Void in
                    self.selectedIndex = 2
                })
                return
            }
            
            // access granted
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CustomCameraNVC")
            
            self.present(
                vc,
                animated: true,
                completion: nil
            )

        }
    }
}

extension TabbarController : UITabBarControllerDelegate {
    
//    // UITabBarDelegate
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        self.selectedIndex = 1
//        print("Selected item")
//        print(item.description)
//    }
//
//    // UITabBarControllerDelegate
//    func tabBarController(_ tabBarController: UITabBarController,
//                          didSelect viewController: UIViewController) {
//        print(viewController)
//
//        //        if viewController == CameraViewController() {
//        //            // Present image picker
//        //            print("yes")
//        //        }
//    }
}
