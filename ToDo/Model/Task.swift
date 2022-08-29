//
//  Task.swift
//  ToDo
//
//  Created by Максим Самусь on 29.08.2022.
//

import Foundation
import RealmSwift
import Realm

class Task: Object {
    @Persisted var title = ""
    @Persisted var done = false
    var parentCategory = LinkingObjects(fromType: CategoryOfTasks.self, property: "task")
}

