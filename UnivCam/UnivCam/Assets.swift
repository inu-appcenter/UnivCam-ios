//
//  Images.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

enum Assets {
    case tutorial1
    case tutorial2
    case tutorial3
    case tutorial4
    case camera
    case favoriteOn
    case favoriteOff
    case leftNavigationItem
}

extension Assets {
    var image : UIImage {
        get {
            switch self {
            case .tutorial1:
                return #imageLiteral(resourceName: "1")
            case .tutorial2:
                return #imageLiteral(resourceName: "2")
            case .tutorial3:
                return #imageLiteral(resourceName: "3")
            case .tutorial4:
                return #imageLiteral(resourceName: "4")
            case .camera:
                return #imageLiteral(resourceName: "icCamera")
            case .favoriteOn:
                return #imageLiteral(resourceName: "ic_star")
            case .favoriteOff:
                return #imageLiteral(resourceName: "icStarBorderWhite")
            case .leftNavigationItem:
                return #imageLiteral(resourceName: "icNavigateNext2X")
            }
        }
    }
}


