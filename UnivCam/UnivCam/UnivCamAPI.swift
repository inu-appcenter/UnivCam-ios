//
//  UnivCamAPI.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 8..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import Foundation

struct UnivCamAPI {
    
    static let baseURLString = UnivCamAPI.getDocPath().appending("/UnivCam")
    
    static func getDocPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
}
