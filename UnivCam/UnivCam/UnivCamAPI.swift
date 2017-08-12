//
//  UnivCamAPI.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 8..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import Foundation

struct UnivCamAPI {
    
    static func baseURL() -> String {
        let documentDirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let mainPath = documentDirPath.appending("/UnivCam")
        return mainPath
    }
    
}
