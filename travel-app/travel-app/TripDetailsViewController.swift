//
//  TripDetailsViewController.swift
//  travel-app
//
//  Created by Rita T on 2025-04-10.
//

import UIKit

class TripDetailsViewController: UIViewController {
    
    var trip: Trip?
    

    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var tripDetails: UILabel!
    @IBOutlet weak var tripName: UILabel!
    
    @IBOutlet weak var tripInfo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let trip = trip else {
                       print("No trip data available!")
                       return
                   }
        
        tripName.text = "Name: " + (trip.name ?? "N/A")
                tripDetails.text = "Details: " + (trip.details ?? "N/A")
                startDate.text = "Departure Date:" + formatDate(trip.startDate)
                endDate.text = "Arrival Date:" + formatDate(trip.endDate)

        
        
    }
    
    func formatDate(_ date: Date?) -> String {
            guard let date = date else {
                   return "N/A"
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd" // Note: use lowercase "yyyy" and "dd"
            return formatter.string(from: date)
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
