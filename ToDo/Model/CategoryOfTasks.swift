//
//  CategoryOfTasks.swift
//  ToDo
//
//  Created by Максим Самусь on 29.08.2022.
//

import Foundation
import RealmSwift

class CategoryOfTasks: Object {
    @Persisted var name = ""
    let task = List<Task>()
}
