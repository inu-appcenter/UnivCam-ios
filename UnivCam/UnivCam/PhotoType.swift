//
//  PhotoType.swift
//  UnivCam
//
//  Created by BLU on 2017. 7. 14..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import UIKit

enum PhotoType {
    case small, big
    var cellSize: CGSize {
        switch self {
        case .small:
            return CGSize(width: 150, height: 150)
        case .big:
            return CGSize(width: 213, height: 213)
        }
    }
    
}
