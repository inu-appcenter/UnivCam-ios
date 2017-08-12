//
//  Palette.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import Foundation
import UIKit

enum Palette {
    case title
    case tabbar
    case navigationTint
}
extension Palette {
    var color : UIColor {
        get {
            switch self {
            case .title:
                return UIColor.init(hex: 0x353946)
            case .tabbar:
                return UIColor.init(hex: 0x353946)
            case .navigationTint:
                return UIColor.lightGray
            }
        }
    }
}

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
