//
//  ExistingTripsViewController.swift
//  travel-app


import UIKit
import CoreData

class ExistingTripsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var currentTrip: UUID?
    var tripCount: Int = 0
    var trips: [Trip] = []
    @IBOutlet weak var tripsView: UITableView!
    
    
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tripsView.dataSource = self
        tripsView.delegate = self
        tripsView.isScrollEnabled = true
        
     //   trips = fetchAllTrips(context)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        trips = fetchAllTrips(context)
        tripsView.reloadData()
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            performSegue(withIdentifier: "showTripDetails", sender: self)
//    }

            
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = trips[indexPath.row]
            
            context.delete(itemToDelete)
            trips.remove(at: indexPath.row)
            
            saveData()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            print("trip deleted")
        }
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
    
    
    
}
