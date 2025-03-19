

import UIKit
import CoreData

class PackingListController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet var Textfields: [UITextField]!
    var items: [Items]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //function to add data
    func fetchData(){
        let request: NSFetchRequest<Items> = Items.fetchRequest()
        items = [Items]()
        do{
            items = try context.fetch(request)
            
        } catch {
            print("error fetching data: \(error.localizedDescription)")
        }
    }

    //Save data
    
    @objc func saveData() {
        do {
            try context.save()
            print("Data saved successfully")
        } catch {
            print("Error while saving data: \(error.localizedDescription)")
        }
    }

    
    @IBAction func addItem(_ sender: UIButton) {
        guard let name = Textfields[0].text, !name.isEmpty,
                  let detail = Textfields[1].text, !detail.isEmpty else {
                let alert = UIAlertController(title: "Error", message: "Please fill in all fields.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }
            
            let item = Items(context: context)
            item.name = name
            item.detail = detail
            
            print("Adding item: \(name), \(detail)")
            
            items?.append(item)
            
            saveData() // Save to Core Data
            
            Textfields.forEach { $0.text = "" }
        
    }
    
    //pass data to the next screen
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemTable = segue.destination as? ItemTableViewController
        itemTable?.items = items
        
    }
}
