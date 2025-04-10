//
//  CreateTripViewController.swift
//  travel-app
//
//  Created by Rita T on 2025-04-10.
//

import UIKit
import CoreData

class CreateTripViewController: UIViewController {

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var departure: UIDatePicker!
    @IBOutlet weak var returning: UIDatePicker!
    @IBOutlet weak var tripNotes: UITextView!
    @IBOutlet weak var tripName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        departure.datePickerMode = .date
        returning.datePickerMode = .date
        // Do any additional setup after loading the view.
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
            newTrip.startDate = departure.date
            newTrip.endDate = returning.date

               // Save the product (use Core Data save method)
               appDelegate.saveContext()
           }
           
           func showErrorMessage(_ message: String) {
                   let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                   self.present(alert, animated: true, completion: nil)
           }
}
