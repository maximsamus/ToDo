//
//  SwipeTableViewController.swift
//  ToDo
//
//  Created by Максим Самусь on 31.08.2022.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController {
    
    var cell: UITableViewCell?
    
    func updateModel(at indexPath: IndexPath) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60.0
    }
    
    // MARK: - Table View Data Source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SwipeTableViewCell else { return UITableViewCell()}
        cell.delegate = self
        return cell
    }
}

extension SwipeTableViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(at: indexPath)
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
