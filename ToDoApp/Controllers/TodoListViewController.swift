import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //dosa si u appDelegate i trazia oni context za spremit podakte
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
        
    }
    
    //vraca samo koliko triba stavit itema u listu
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //stvara celije i puni ih s tekstom 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title

        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }else {
//            cell.accessoryType = .none
//        }
//        
        return cell
        
    } 
    //MARK: - TableView Delegate funkcije
        
    //skida i dodaje checkmark
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - plusButtonPressed
//kad se stisne oni plus da izade prozor za unit novi task
    @IBAction func plusButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //stavaran popup
        let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
        
        //stvaran botun na popupu
        let action = UIAlertAction(title: "Add New Item", style: .default) { action in
            //moras dodat ono sta bude u textfieldu i onda reload da se ucita ispocetka to novo
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)
            
//            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItems()
                
        }
        
        //za stvorit unos texta u popupu
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - saveItems
    //uzet ce podatke koje ja unesen u apk i poslat ih u neki plis file
    func saveItems() {
        do {
            //nasa si ovu liniju u appDelegate liniju za spremit podatke
            try self.context.save()
        }catch {
            print("error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
//    MARK: - loadItems
//    uzet ce podatke iz plist filea i stavit ih u apk
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        }catch {
            print("error fetching data \(error)")
        }
        tableView.reloadData()
    }
    
    
}

//MARK: - Search bar funkcije
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
        
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
