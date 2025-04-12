//
//  ExpenseTrackerViewController.swift
//  travel-app
//

import UIKit
import CoreData

class ExpenseTrackerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var trip: Trip?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var expensesCount: Int = 0
    var expenses: [Expense] = []
    
    
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var expenseName: UITextField!
    @IBOutlet weak var expenseAmount: UITextField!
    
    @IBOutlet weak var expenseTable: UITableView!
    
    @IBOutlet weak var btnAdd: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        expenseTable.dataSource = self
        expenseTable.delegate = self
        expenseTable.isScrollEnabled = true
        
        fetchExpenses(context)
        lblTotal.text = String(format: "Total: $%.2f", calculateTotalExpenses())
    }
    
    func calculateTotalExpenses() -> Double {
        return expenses.reduce(0) { $0 + $1.amount }
    }
    
    func fetchExpenses(_ context: NSManagedObjectContext) {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        if let tripID = trip?.id {
            request.predicate = NSPredicate(format: "id == %@", tripID as CVarArg)
        }

        do {
            self.expenses = try context.fetch(request)
            print("Fetched \(expenses.count) expenses for trip \(trip?.name ?? "Unknown")")
        } catch {
            print("Failed to fetch expenses: \(error.localizedDescription)")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = expenses[indexPath.row]
            
            context.delete(itemToDelete)
            expenses.remove(at: indexPath.row)
            
            saveData()
            tableView.deleteRows(at: [indexPath], with: .fade)
            lblTotal.text = String(format: "Total: $%.2f", calculateTotalExpenses())
            
            print("expense deleted")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell", for: indexPath)
        cell.textLabel?.text = expenses[indexPath.row].name
        cell.detailTextLabel?.text = "\(expenses[indexPath.row].amount)"
        return cell
    }
    
    
    @IBAction func addExpense(_ sender: UIButton) {
        guard let expenseName = expenseName.text,
              let expenseAmountText = expenseAmount.text,
              let expenseID: UUID = trip?.id,
                  !expenseName.isEmpty,
                  !expenseAmountText.isEmpty,
              let amount = Double(expenseAmountText) else{
            
            let alert = UIAlertController(title:"Error", message:"Expense name cannot be empty or amount must be a valid number", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title:"OK", style: .default))
            present(alert,animated:true)
            return
        }
        
        let newExpense = Expense(context:context)
        newExpense.id = expenseID
        newExpense.name = expenseName
        newExpense.amount = amount
        
        expenses.append(newExpense)
        saveData()
        self.expenseName.text = ""
        self.expenseAmount.text = ""
        print("New expense added")
        
        expenseTable.reloadData()
        lblTotal.text = String(format: "Total: $%.2f", calculateTotalExpenses())
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
        if segue.identifier == "backFromExpense",
           let destinationVC = segue.destination as? TripDetailsViewController,
           let tripToSend = trip {
            destinationVC.trip = tripToSend
        }
    }
}
