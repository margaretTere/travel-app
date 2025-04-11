//
//  CreateTripViewController.swift
//  travel-app
//

//

import UIKit
import CoreData

class CreateTripViewController: UIViewController {

    @IBOutlet weak var tripName: UITextField!
    @IBOutlet weak var tripNotes: UITextView!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    
    @IBOutlet weak var btnAdd: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startDate.datePickerMode = .date
        endDate.datePickerMode = .date
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func addTrip(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if tripName.text?.isEmpty ?? true {
            showErrorMessage("Trip name is required")
            return
        }

        let newTrip = Trip(context: appDelegate.persistentContainer.viewContext)
        newTrip.id = UUID()
        newTrip.name = tripName.text
        newTrip.details = tripNotes.text
        newTrip.startDate = startDate.date
        newTrip.endDate = endDate.date

        // Save the product (use Core Data save method)
        appDelegate.saveContext()
    }
    
    func showErrorMessage(_ message: String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
    
}
