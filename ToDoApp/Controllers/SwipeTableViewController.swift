//
//  SwipeTableViewController.swift
//  ToDoApp
//
//  Created by Luka Vujnovac on 21.07.2021..
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
               
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { 
            
            let editAction = SwipeAction(style: .default, title: "edit") { action, indexPath in
                self.editModel(at: indexPath)
            }
            editAction.image = UIImage(systemName: "pencil.circle.fill")
            editAction.backgroundColor = .systemBlue
            return [editAction]
        }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
               // handle action by updating model with deletion
            self.updateModel(at: indexPath)     
        }
           // customize the action appearance
        deleteAction.image = UIImage(systemName: "trash.circle.fill")
        
           return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {}
    
    func pinModel(at indexPath: IndexPath) {}
    
    func editModel(at indexPath: IndexPath) {}

}
