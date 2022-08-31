//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Максим Самусь on 28.08.2022.
//

import UIKit
import RealmSwift
import SwipeCellKit

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var tasksCategories: Results<CategoryOfTasks>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    
    private func save(category: CategoryOfTasks) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    private func loadCategory() {
        
        tasksCategories = realm.objects(CategoryOfTasks.self)
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(
            title: "Add s new task group",
            message: "",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Add a new task group", style: .default) { action in
            
            let newTaskCategory = CategoryOfTasks()
            newTaskCategory.name = textField.text ?? ""
            self.save(category: newTaskCategory)
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Please create a new task group"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}

// MARK: - Table View Data Source Methods
extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasksCategories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as? SwipeTableViewCell else { return UITableViewCell()}
        
        cell.textLabel?.text = tasksCategories?[indexPath.row].name ?? "No categories added"
        cell.delegate = self
        return cell
    }
}

// MARK: - Table View Data Source Methods
extension CategoryViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let taskVS = segue.destination as? ToDoListViewController else { return }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        taskVS.selectedCategory = tasksCategories?[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTasks", sender: self)
    }
}

// MARK: - Swipe Table View Cell Delegate
extension CategoryViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let categoryOFDeletion = self.tasksCategories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryOFDeletion)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
