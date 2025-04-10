//
//  ExistingTripsViewController.swift
//  travel-app
//
//  Created by Rita T on 2025-04-10.
//

import UIKit
import CoreData

class ExistingTripsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var currentTrip: UUID?
      var tripCount: Int = 0
      var trips: [Trip] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tripsView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let context = appDelegate.persistentContainer.viewContext
         
         tripsView.dataSource = self
         tripsView.delegate = self
         
         trips = fetchAllTrips(context)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTripDetails", sender: self)
    }

        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTripDetails" {
            if let destinationVC = segue.destination as? TripDetailsViewController,
               let indexPath = tripsView.indexPathForSelectedRow {
                let selectedTrip = trips[indexPath.row]
                destinationVC.trip = selectedTrip
            }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        cell.textLabel?.text = trips[indexPath.row].name
        cell.detailTextLabel?.text = trips[indexPath.row].details
        return cell
    }

    func fetchAllTrips(_ context: NSManagedObjectContext) -> [Trip] {
           let request: NSFetchRequest<Trip> = Trip.fetchRequest()
           do {
               let trips = try context.fetch(request)
               tripCount = trips.count

               return trips
           } catch {
               fatalError("Failed to fetch trips: \(error)")
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

}
