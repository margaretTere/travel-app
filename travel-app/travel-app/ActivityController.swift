//
//  ActivityController.swift
//  travel-app
//
//  Created by Akeen on 2025-03-20.
//


import UIKit
import CoreData

class ActivityController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet var Textfields:[UITextField]!
    var activities:[Activity]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func addActivity(_ sender: UIButton){
        guard let activityTitle = Textfields[0].text,
              let activityLocation = Textfields[1].text,
              let activityTime = Textfields[2].text,
              let activityDetails = Textfields[3].text else{
            
            let alert = UIAlertController(title:"Error", message:"Title and location cannot be empty", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title:"OK", style: .default))
            present(alert,animated:true)
            return
        } //end else
        
        let activity = Activity(context:context)
        activity.title = activityTitle
        activity.location = activityLocation
        activity.time = activityTime
        activity.details = activityDetails
        
        activities?.append(activity)
        saveData()
        Textfields.forEach{$0.text=""}
        print("New activity added")
    }//end addActivity
              
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let activityTable = segue.destination as? ItinieraryTableViewController
        activityTable?.activities = activities
    }
  
    
}

