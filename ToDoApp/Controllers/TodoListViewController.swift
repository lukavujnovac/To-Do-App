import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {

    var toDoItems: Results<Item>?
    
    var selectedItemId = ObjectId.generate()
    
    let realm = try! Realm()
    
    var selectedCategory: Category?  {
        didSet {
            loadItems()
        }
    }
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.0
        
        self.navigationItem.title = selectedCategory?.name
    }
    //MARK: - TableView Delegate funkcije
    
    //vraca samo koliko triba stavit itema u listu
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    //stvara celije i puni ih s tekstom 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title

            cell.accessoryType = item.done ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//        }
//        
        return cell
        
    }
    
    //fali ti jos za editad iteme
        
    //skida i dodaje checkmark
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
//                    realm.delete(item)
                }
            }catch {
                print("error adding checkmark \(error)")
            } 
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - plusButtonPressed
//kad se stisne oni plus da izade prozor za unit novi task
    @IBAction func plusButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //stavaran popup
        let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
        
        //stvaran botun na popupu
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            //moras dodat ono sta bude u textfieldu i onda reload da se ucita ispocetka to novo

            if let currentCategory = self.selectedCategory {
    
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch {
                    print("error u spremanju nove kategorije \(error)")
                }

            }
            self.tableView.reloadData()
                
        }
        
        //za stvorit unos texta u popupu
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
//    MARK: - loadCategories
//    uzet ce podatke iz plist filea i stavit ih u apk
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
//        let categoryPredicate = NSPredicate(format: "parentCategory.name CONTAINS %@", selectedCategory!.name!)
//        
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        }else {
//            request.predicate = categoryPredicate
//        }
//      
//        do {
//            toDoItems = try context.fetch(request)
//        }catch {
//            print("error fetching data \(error)")
//        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        let deleteAlert = UIAlertController(title: "Delete \(toDoItems![indexPath.row].title)", message: "press 'Confirm' to delete", preferredStyle: .alert)
        
        let confirmButton = UIAlertAction(title: "Confirm", style: .destructive) { action in
            if let itemForDeletion = self.toDoItems?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(itemForDeletion)
                    }
                }catch {
                    print("error kod brisanja itema \(error)")
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
        
        selectedItemId = toDoItems![indexPath.row]._id
        
        var textField = UITextField()
        
        let editAlert = UIAlertController(title: "Edit Item Title", message: "", preferredStyle: .alert)
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { action in
            let editedItem = Item(value: ["_id": self.selectedItemId, "title": textField.text])
            
            do {
                try self.realm.write{
                    self.realm.add(editedItem, update: .modified)
                }
            }catch {
                print("error editing items \(error)")
            }
            
            self.tableView.reloadData()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        editAlert.addTextField { alertTextField in
            alertTextField.placeholder = "Changed Item Title"
            textField = alertTextField
        }
        
        editAlert.addAction(cancelButton)
        editAlert.addAction(saveButton)
        
        
        present(editAlert, animated: true, completion: nil)
    }
    
}

//MARK: - Search bar funkcije
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] 
//        loadCategories(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }



}
