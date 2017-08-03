//
//  TabbarController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 15..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController, UITabBarControllerDelegate {
    
    lazy var button : UIButton = {
        var btn : UIButton = .init(type: .custom)
        btn.setTitle("Cam", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.yellow, for: .highlighted)
        btn.backgroundColor = .orange
        btn.layer.cornerRadius = 32
        btn.layer.borderWidth = 4
        btn.layer.borderColor = UIColor.yellow.cgColor
        btn.addTarget(self, action: #selector(switchView), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.insertSubview(button, aboveSubview: self.tabBar)
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // safe place to set the frame of button manually
        button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 54, width: 64, height: 64)
        self.tabBar.tintColor = UIColor(hex: 0x353946)
        self.tabBar.unselectedItemTintColor = UIColor(hex: 0xBABAC0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.selectedIndex = 1
           }
    // UITabBarDelegate
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item")
        print(item.description)
    }
    
    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        print(viewController)
        //self.showCameraView()
//        if viewController == CameraViewController() {
//            // Present image picker
//            print("yes")
//        }
    }


}

extension TabbarController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func showCameraView() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(
            imagePicker,
            animated: true,
            completion: nil
        )
    }

}
