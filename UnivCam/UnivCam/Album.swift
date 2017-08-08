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
    
    dynamic var id = 0
    dynamic var title = ""
    dynamic var createdAt = NSDate()
    dynamic var url = ""
    
    static func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Album.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    override static func primaryKey() -> String? {
        return "id"
    }
}
