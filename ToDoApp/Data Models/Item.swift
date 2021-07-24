//
//  Category.swift
//  ToDoApp
//
//  Created by Luka Vujnovac on 19.07.2021..
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
