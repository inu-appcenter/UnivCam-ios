//
//  Album.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 8..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import Foundation
import RealmSwift

class Album: Object {
    
    dynamic var id = UUID().uuidString
    dynamic var title = ""
    dynamic var isFavorite : Bool = false
    dynamic var createdAt = Date()
    dynamic var url = ""
    dynamic var coverImageData : NSData? = nil
    dynamic var photoCount = 0
    
    var photos = List<Photo>() // 1대 다 관계
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
