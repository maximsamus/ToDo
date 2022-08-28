//
//  ToDoListViewController.swift
//  ToDo
//
//  Created by Максим Самусь on 20.08.2022.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tasks = [Task]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTask()
    }
    
    private func saveTask() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
    }
    
    private func loadTask(with request: NSFetchRequest<Task> = Task.fetchRequest()) {
        do {
            tasks = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
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
            
            let newTask = Task(context: self.context)
            newTask.title = textField.text
            newTask.done = false
            self.tasks.append(newTask)
            self.saveTask()
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
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        let item = tasks[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    // MARK: - Delegate Method didSelectRowAt
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        context.delete(tasks[indexPath.row])
        //        tasks.remove(at: indexPath.row)
        
        tasks[indexPath.row].done = !tasks[indexPath.row].done
        saveTask()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
// MARK: - Search Bar

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadTask(with: request)
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
