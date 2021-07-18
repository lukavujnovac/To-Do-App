//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Luka Vujnovac on 17.07.2021..
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryArray = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
    }
    
    //MARK: - TableView source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    //MARK: - Data Manipulaton methods
    
    func saveItems() {
        do {
            try self.context.save()
        }catch {
            print("error u spremanju nove kategorije \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        }catch {
            print("error kod ucitavanja kategorija \(error)")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        //stavaran popup
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        //stvaran botun na popupu
        let action = UIAlertAction(title: "Add", style: .default) { action in
            //moras dodat ono sta bude u textfieldu i onda reload da se ucita ispocetka to novo
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            
            self.saveItems()
        }
    
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "add a new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    
    }
    //MARK: - TableView Delegate methods

}
