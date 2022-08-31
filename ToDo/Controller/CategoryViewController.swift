//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Максим Самусь on 28.08.2022.
//

import UIKit
import RealmSwift

class CategoryViewController: SwipeTableViewController {
    
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
    
    override func updateModel(at indexPath: IndexPath) {
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = tasksCategories?[indexPath.row].name ?? "No categories added"
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
