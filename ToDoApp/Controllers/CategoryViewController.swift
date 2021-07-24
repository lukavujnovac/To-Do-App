//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Luka Vujnovac on 17.07.2021..
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: SwipeTableViewController{
   
    let realm = try! Realm()
    
    var selectedCategoryId = ObjectId.generate()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.rowHeight = 80.0
        
        loadCategories()
        
    }
    
    //MARK: - TableView source methods
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SwipeCollectionViewCell
//        cell.delegate = self
//        return cell
//    }
//    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
//        let category = categoryArray?[indexPath.row]
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Category Added"
        
        return cell
    }
    
    //MARK: - Data Manipulaton methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        }catch {
            print("error u spremanju nove kategorije \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - swipeActions
    
    override func updateModel(at indexPath: IndexPath) {
        
        let deleteAlert = UIAlertController(title: "Delete \(categoryArray![indexPath.row].name)", message: "press 'Confirm' to delete", preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "Confirm", style: .destructive) { action in
            if let categoryForDeletion = self.categoryArray?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryForDeletion)
                    }
                }catch {
                    print("error kod brisanja kategorije \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        deleteAlert.addAction(confirmButton)
        deleteAlert.addAction(cancelButton)
        
        present(deleteAlert, animated: true, completion: nil)
        
    }
    
    override func editModel(at indexPath: IndexPath) {
        
        selectedCategoryId = categoryArray![indexPath.row]._id
        
        var textField = UITextField()
        
        var numberOfItems = 0
        
        if categoryArray == nil {
            numberOfItems = 0
        }else {
            numberOfItems = categoryArray![indexPath.row].items.count
        }
        
        let editAlert = UIAlertController(title: "Edit Category", message: "you are editing: \(categoryArray![indexPath.row].name)", preferredStyle: .alert)
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { action in
            let editedCategory = Category(value: ["_id": self.selectedCategoryId, "name": textField.text])
            
            do {
                try self.realm.write{
                    self.realm.add(editedCategory, update: .modified)
                }
            }catch {
                print("error editing categories \(error)")
            }
            
            self.tableView.reloadData()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        editAlert.addTextField { alertTextField in
            alertTextField.placeholder = "Changed Category Name"
            textField = alertTextField
        }
        
        editAlert.addAction(cancelButton)
        editAlert.addAction(saveButton)
        
        
        present(editAlert, animated: true, completion: nil)
    }

    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let text = UITextView()
        
        //stavaran popup
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        //stvaran botun na popupu
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            //moras dodat ono sta bude u textfieldu i onda reload da se ucita ispocetka to novo
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
    
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "add a new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    
    }
    //MARK: - TableView Delegate methods

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        if categoryArray!.count > 0 {
            selectedCategoryId = categoryArray![indexPath.row]._id
        }
        
        print(selectedCategoryId)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
}


