//
//  CheckListViewController.swift
//  travel-app
//

//

import UIKit
import CoreData

class CheckListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var trip: Trip?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemsCount: Int = 0
    var items: [Item] = []
    @IBOutlet weak var checkListTable: UITableView!
    
    
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemDetails: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        checkListTable.dataSource = self
        checkListTable.delegate = self
        checkListTable.isScrollEnabled = true
        
        fetchItems(context)
    }
    
    func fetchItems(_ context: NSManagedObjectContext) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        if let tripID = trip?.id {
            request.predicate = NSPredicate(format: "id == %@", tripID as CVarArg)
        }

        do {
            self.items = try context.fetch(request)
            print("Fetched \(items.count) items for trip \(trip?.name ?? "Unknown")")
        } catch {
            print("Failed to fetch items: \(error.localizedDescription)")
        }
    }
    
    @IBAction func addItem(_ sender: UIButton) {
        guard let itemName = itemName.text,
              let itemDetails = itemDetails.text,
              let itemID: UUID = trip?.id,
                  !itemName.isEmpty,
                  !itemDetails.isEmpty else{
            
            let alert = UIAlertController(title:"Error", message:"Name and details cannot be empty", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title:"OK", style: .default))
            present(alert,animated:true)
            return
        }
        
        let newItem = Item(context:context)
        newItem.id = itemID
        newItem.name = itemName
        newItem.detail = itemDetails
        newItem.packed = false
        
        items.append(newItem)
        saveData()
        self.itemName.text = ""
        self.itemDetails.text = ""
        print("New item added")
        
        checkListTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the item tapped
        let selectedItem = items[indexPath.row]
        
        // Toggle its packed state
        selectedItem.packed.toggle()

        // Save the change to Core Data
        saveData()
        
        // Reload the row to reflect the change visually
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = items[indexPath.row]
            
            context.delete(itemToDelete)
            items.remove(at: indexPath.row)
            
            saveData()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            print("Item deleted")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListCell", for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.detail ?? "no details"
        
        if item.packed {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = .gray
        } else {
            cell.accessoryType = .none
            cell.textLabel?.textColor = .label
        }
        
        return cell
    }


    @objc func saveData() {
        do {
            try context.save()
            print("Data saved successfully")
        } catch {
            print("Error while saving data: \(error.localizedDescription)")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backFromCheckList",
           let destinationVC = segue.destination as? TripDetailsViewController,
           let tripToSend = trip {
            destinationVC.trip = tripToSend
        }
    }
}
