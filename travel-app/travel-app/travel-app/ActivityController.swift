//
//  ActivityController.swift
//  travel-app
//
//  Created by Akeen on 2025-03-20.
//


import UIKit
import CoreData

class ActivityController: UIViewController {
    
    var trip: Trip!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var activities:[Activity]?
    @IBOutlet weak var activityTime: UIDatePicker!
    @IBOutlet weak var actTitle: UITextField!
    @IBOutlet weak var actLocation: UITextField!
    @IBOutlet weak var actDetails: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let trip = trip else {
               print("No trip data available!")
               return
           }
        fetchActivities()
    }
    
    func fetchActivities(){
        do{
            self.activities = try context.fetch(Activity.fetchRequest())
            
            /*
             DispatchQueue.main.async{
                self.tableView.reloadData()
             }
             
             */
        }
        catch{
                
            }
        
    } //end fetchActivities
    
    @objc func saveActivity(){
        do{
            try context.save()
        }
        catch{
            
        }
    } //end saveActivities
    
    @objc func saveData() {
        do {
            try context.save()
            print("Data saved successfully")
        } catch {
            print("Error while saving data: \(error.localizedDescription)")
        }
    } //end saveData
    
    func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH-mm-ss" // Lowercase for correct date/time components
        return formatter.string(from: date)
    }
    
    @IBAction func addActivity(_ sender: UIButton){
        guard let activityTitle = actTitle.text,
              let activityLocation = actLocation.text,
              let activityDetails = actDetails.text,
              let activityID: UUID = trip.id else{
            
            let alert = UIAlertController(title:"Error", message:"Title and location cannot be empty", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title:"OK", style: .default))
            present(alert,animated:true)
            return
        } //end else
        
        let activity = Activity(context:context)
        activity.id = activityID
        activity.title = activityTitle
        activity.location = activityLocation
        activity.time = formatDateTime(activityTime.date)
        activity.details = activityDetails
        
        activities?.append(activity)
        saveData()
        actTitle.text = ""
        actLocation.text = ""
        actDetails.text = ""
        print("New activity added")
    }//end addActivity
              
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
//        let activityTable = segue.destination as? ItinieraryTableViewController
//        activityTable?.activities = activities
//    }
 
    @IBAction func goBackToList(_ sender: Any) {
        performSegue(withIdentifier: "backToActivityList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToActivityList",
           let destinationVC = segue.destination as? ActivitiesListViewController,
           let tripToSend = trip {
            destinationVC.trip = tripToSend
        }
    }
    
}

