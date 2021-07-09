import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["nesto za napravit", "jos nesto za napravit", "nesto trece za napravit"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
        
    }
    
    //vraca samo koliko triba stavit itema u listu
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //stvara celije i puni ih s tekstom 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    } 
        
    //skida i dodaje checkmark
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
    
//kad se stisne oni plus da izade prozor za unit novi task
    @IBAction func plusButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //stavaran popup
        let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
        
        //stvaran botun na popupu
        let action = UIAlertAction(title: "Add New Item", style: .default) { action in
            //moras dodat ono sta bude u textfieldu i onda reload da se ucita ispocetka to novo
            self.itemArray.append(textField.text!)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }
        
        //za stvorit unos texta u popupu
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
}
