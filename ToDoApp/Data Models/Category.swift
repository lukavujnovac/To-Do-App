//
//  Item.swift
//  ToDoApp
//
//  Created by Luka Vujnovac on 19.07.2021..
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    let items = List<Item>()
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
