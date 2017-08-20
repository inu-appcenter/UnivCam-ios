//
//  Device.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 16..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit
//struct Device {
//    static let screenSize = UIScreen.main.bounds
//    static let screenWidth = Device.screenSize.width
//    static let screenHeight = Device.screenSize.height
//
//}
struct DeviceUtil {
//    static var type : Device.heightSize {
//        get {
//            switch self {
//            case .iphone4.heightSize
//                return .iphone4.heightSize
//            }
//        }
//    }
    
}
enum Device {
    case iphone4
    case iphone5
    case iphone6
    case iphone7plus
    var heightSize: CGFloat {
        get {
            switch self {
            case .iphone4:
                return 0
            case .iphone5:
                return 1
            case .iphone6:
                return 2
            case .iphone7plus:
                return 3
            }
        }
    }
    
}
//extension Device {
//    var size : self {
//        get {
//
//        }
//    }
//}


