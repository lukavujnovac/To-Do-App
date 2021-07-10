import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem1 = Item()
        newItem1.title = "novi item 1"
        itemArray.append(newItem1)
        
        let newItem2 = Item()
        newItem2.title = "novi item 2"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "novi item 3"
        itemArray.append(newItem3)
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
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
        
    //skida i dodaje checkmark
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()

        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//kad se stisne oni plus da izade prozor za unit novi task
    @IBAction func plusButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //stavaran popup
        let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
        
        //stvaran botun na popupu
        let action = UIAlertAction(title: "Add New Item", style: .default) { action in
            //moras dodat ono sta bude u textfieldu i onda reload da se ucita ispocetka to novo
            let newItem = Item()
            newItem.title = textField.text!
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
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch {
            print("Error u catch bloku, \(error)")
        }
        
        tableView.reloadData()
    }
}
