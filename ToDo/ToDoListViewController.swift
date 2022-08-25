//
//  ToDoListViewController.swift
//  ToDo
//
//  Created by Максим Самусь on 20.08.2022.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    let dataFilePath = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask
    ).first?.appendingPathComponent("Tasks.plist")
    
    var tasks = [Task]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTask()
    }
    
    private func saveTask() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(tasks)
            try data.write(to: dataFilePath!)
        } catch {
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
    }
    
    private func loadTask() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                tasks = try decoder.decode([Task].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Add New Task
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(
            title: "Add new task",
            message: "",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Add item", style: .default) { action in
            let newTask = Task(title: textField.text ?? "", done: false)
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
        
        tasks[indexPath.row].done = !tasks[indexPath.row].done
        saveTask()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

