
//
//  DeviceUtil.swift
//  SmartCampus
//
//  Created by BLU on 2017. 3. 24..
//  Copyright © 2017년 INUAPPCENTER. All rights reserved.
//
import UIKit

class DeviceUtility: NSObject {
    
    static var screenSize: CGRect!
    static var screenWidth: CGFloat!
    static var screenHeight: CGFloat!
    
    
    static func knowScreenWidth() -> CGFloat {
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        
        return screenWidth
    }
    
    static func knowScreenHeight() -> CGFloat {
        
        screenSize = UIScreen.main.bounds
        screenHeight = screenSize.height
        
        return screenHeight
    }
    
    static func knowDeviceSize() -> Int {
        
        self.screenSize = UIScreen.main.bounds
        self.screenWidth = screenSize.width
        self.screenHeight = screenSize.height
        
        if (screenHeight <= 480){
            
            return 0
            //iphone 4s
        } else if (480 < screenHeight && screenHeight <= 568){
            
            return 1
            //iphone 5,5s,SE
        } else if (568 < screenHeight && screenHeight <= 667){
            
            return 2
            //iphone 6,6s
        } else if (667 < screenHeight && screenHeight <= 736){
            
            return 3
            //iphone 6 plus
        }
        
        return -1
    }
    
}
