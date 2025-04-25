//
//  TripDetailsViewController.swift
//  travel-app
//


import UIKit

class TripDetailsViewController: UIViewController {
    
    var trip: Trip?

    @IBOutlet weak var tripName: UILabel!
    @IBOutlet weak var tripDetails: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    
    @IBOutlet weak var btnActivities: UIButton!
    @IBOutlet weak var btnExpense: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)

        
           // Ensure the data is set before updating UI
        guard let trip = trip else {
               print("No trip data available!")
               return
           }

        tripName.text = "Name: " + (trip.name ?? "N/A")
        tripDetails.text = "Details: " + (trip.details ?? "N/A")
        startDate.text = "Departure:" + formatDate(trip.startDate)
        endDate.text = "Arrival:" + formatDate(trip.endDate)
       }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func formatDate(_ date: Date?) -> String {
        guard let date = date else {
               return "N/A"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Note: use lowercase "yyyy" and "dd"
        return formatter.string(from: date)
    }

    @IBAction func goToExpense(_ sender: UIButton) {
        //performSegue(withIdentifier: "showExpense", sender: self)
    }
    
    @IBAction func goToActivities(_ sender: UIButton) {
        //performSegue(withIdentifier: "showActivities", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showActivities",
           let destinationVC = segue.destination as? ActivitiesListViewController,
           let tripToSend = trip {
            destinationVC.trip = tripToSend
        }
        
        if segue.identifier == "showExpense",
           let destinationVC = segue.destination as? ExpenseTrackerViewController,
           let tripToSend = trip {
            destinationVC.trip = tripToSend
        }
        
        if segue.identifier == "showCheckList",
           let destinationVC = segue.destination as? CheckListViewController,
           let tripToSend = trip {
            destinationVC.trip = tripToSend
        }
    }
}
