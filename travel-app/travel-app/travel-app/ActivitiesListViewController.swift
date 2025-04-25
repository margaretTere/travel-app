//
//  ActivitiesListViewController.swift
//  travel-app
//


import UIKit
import CoreData

class ActivitiesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var trip: Trip?
    var actsCount: Int = 0
    var activities: [Activity] = []
    @IBOutlet weak var activitiesTable: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activitiesTable.dataSource = self
        activitiesTable.delegate = self
        activitiesTable.isScrollEnabled = true
        
        //fetchActivities(context)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchActivities(context)
        activitiesTable.reloadData()
    }
    
    func fetchActivities(_ context: NSManagedObjectContext) {
        let request: NSFetchRequest<Activity> = Activity.fetchRequest()
        
        if let tripID = trip?.id {
            request.predicate = NSPredicate(format: "id == %@", tripID as CVarArg)
        }

        do {
            self.activities = try context.fetch(request)
            print("Fetched \(activities.count) activities for trip \(trip?.name ?? "Unknown")")
        } catch {
            print("Failed to fetch activities: \(error.localizedDescription)")
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = activities[indexPath.row]
            
            context.delete(itemToDelete)
            activities.remove(at: indexPath.row)
            
            saveData()
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            print("activity deleted")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)
        cell.textLabel?.text = activities[indexPath.row].title
        cell.detailTextLabel?.text = "\(activities[indexPath.row].details ?? "no details"), \(activities[indexPath.row].location ?? "no location"), \(activities[indexPath.row].time ?? "no time set")"
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addActivity(_ sender: UIButton) {
        //performSegue(withIdentifier: "showAddActivity", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddActivity",
           let destinationVC = segue.destination as? ActivityController,
           let tripToSend = trip {
            destinationVC.trip = tripToSend
        }
        
        if segue.identifier == "backToTripInfo" ,
           let destinationVC = segue.destination as? TripDetailsViewController,
           let tripToSend = trip {
            destinationVC.trip = tripToSend
        }
    }
    
    
    
}
