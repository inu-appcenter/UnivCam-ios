//
//  TabbarController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 15..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import AVFoundation
import UIKit

enum TapViewControllers : Int {
    case home = 0
    case search
    case camera
    case favorite
    case setting
}

class TabbarController: UITabBarController {
    
    lazy var button : UIButton = {
        var btn : UIButton = .init(type: .custom)
        btn.setImage(Assets.camera.image,
                     for: .normal)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self,
                      action: #selector(showCamera),
                      for: .touchUpInside)
        btn.frame = .init(x: self.tabBar.center.x - 32,
                          y: self.view.bounds.height - 49,
                          width: 64,
                          height: 50)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = Palette.tabbar.color
        self.tabBar.addSubview(self.button)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        let v = self.tabBarButtons()[2]
        button.frame = v.frame
//        if let v = v {
//        button.frame = v.frame
        //}
    }
    
    func showCamera(){
        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) {
            (granted: Bool) -> Void in
            guard granted else {
                /// Report an error. We didn't get access to hardware.
                DispatchQueue.main.async(execute: { () -> Void in
                    self.selectedIndex = TapViewControllers.camera.rawValue
                })
                return
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                // access granted
                let vc = ViewControllers.custom_camera.instance
                self.present(
                    vc,
                    animated: true,
                    completion: nil
                )
            })
        }
    }
}

extension UITabBarController{
    func tabBarButtons()->[UIView]{
        return self.tabBar.subviews.reduce([], { (ret:[UIView], item:AnyObject) -> [UIView] in
            if let v = item as? UIView  {
                if v.isKind(of: NSClassFromString("UITabBarButton")!) {
                    return ret + [v]
                }
            }
            return ret
        })
    }
}
