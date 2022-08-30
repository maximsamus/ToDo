//
//  ToDoListViewController.swift
//  ToDo
//
//  Created by Максим Самусь on 20.08.2022.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    let realm = try! Realm()
    var tasks: Results<Task>?
    var selectedCategory: CategoryOfTasks? {
        didSet {
            loadTask()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func loadTask() {
        
        tasks = selectedCategory?.task.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    // MARK: - Add New Task
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(
            title: "Add a new task",
            message: "",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Add a new task", style: .default) { action in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newTask = Task()
                        newTask.title = textField.text ?? ""
                        newTask.dateCreated = Date()
                        currentCategory.task.append(newTask)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                
            }
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Please create a new task"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}
// MARK: - Table View

extension ToDoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        if let item = tasks?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No tasks added"
        }
        return cell
    }
    // MARK: - Delegate Method didSelectRowAt
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let task = tasks?[indexPath.row] {
            do {
                try realm.write {
                    task.done = !task.done
                    //                    realm.delete(task)
                }
            } catch {
                print(error.localizedDescription)
            }
            self.tableView.reloadData()
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
// MARK: - Search Bar

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        tasks = tasks?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadTask()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
