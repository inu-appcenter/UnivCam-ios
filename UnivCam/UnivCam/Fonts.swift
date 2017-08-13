//
//  Fonts.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 13..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

enum Fonts {
    case navigationTitle
}

extension Fonts {
    var style : UIFont {
        get {
            switch self {
            case .navigationTitle:
                return UIFont(name: "AppleSDGothicNeo-Regular", size:36)!
            }
        }
    }
}
