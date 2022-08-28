//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Максим Самусь on 28.08.2022.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasksCategories = [CategoryOfTasks]()
    
    
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
    
    private func loadTask(with request: NSFetchRequest<CategoryOfTasks> = CategoryOfTasks.fetchRequest()) {
        do {
            tasksCategories = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(
            title: "Add s new task group",
            message: "",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "Add a new task group", style: .default) { action in
            
            let groupTask = CategoryOfTasks(context: self.context)
            groupTask.name = textField.text
            self.tasksCategories.append(groupTask)
            self.saveTask()
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
        tasksCategories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = tasksCategories[indexPath.row]
        
        cell.textLabel?.text = item.name
        return cell
    }
}
