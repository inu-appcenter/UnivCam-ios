//
//  TabbarController.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 15..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
