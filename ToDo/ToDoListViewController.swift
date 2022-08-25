//
//  ToDoListViewController.swift
//  ToDo
//
//  Created by Максим Самусь on 20.08.2022.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
//    let userDefaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask
    ).first?.appendingPathComponent("Tasks.plist") 
//    print(dataFilePath ?? "")

    var tasks = [Task]()
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let newTask = Task(title: "Test", done: false)
        tasks.append(newTask)
        
        let newTask2 = Task(title: "Test2", done: false)
        tasks.append(newTask2)
        
//        tasks = userDefaults.array(forKey: "ToDoTasks") as? [Task] ?? []
    }
    
    // MARK: - Add New Task
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(
            title: "Add new task",
            message: "",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Add item", style: .default) { [self] action in
            
            let newTask = Task(title: textField.text ?? "", done: false)
//            newTask.title = textField.text
            self.tasks.append(newTask)
//            userDefaults.set(tasks, forKey: "ToDoTasks")
            let encoder = PropertyListEncoder()
            do {
            let data = try encoder.encode(tasks)
                try data.write(to: dataFilePath!)
            } catch {
                print(error.localizedDescription)
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

extension ToDoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        let item = tasks[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        return cell
    }
    
    // MARK: - Delegate Method didSelectRowAt
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tasks[indexPath.row].done = !tasks[indexPath.row].done
        
//        if tasks[indexPath.row].done == false {
//            tasks[indexPath.row].done = true
//        } else {
//            tasks[indexPath.row].done = false
//        }
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

