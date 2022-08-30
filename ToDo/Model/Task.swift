//
//  Task.swift
//  ToDo
//
//  Created by Максим Самусь on 29.08.2022.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    var parentCategory = LinkingObjects(fromType: CategoryOfTasks.self, property: "task")
}


