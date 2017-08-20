//
//  Photo.swift
//  UnivCam
//
//  Created by BLU on 2017. 8. 14..
//  Copyright © 2017년 futr_blu. All rights reserved.
//

import Foundation
import RealmSwift

class Photo: Object {
    
    dynamic var id = UUID().uuidString
    dynamic var createdAt = Date()
    dynamic var url = ""
    
    let album = LinkingObjects(fromType: Album.self, property: "photos")
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
