//
//  ItinieraryTableViewController.swift
//  travel-app
//
//  Created by Akeen on 2025-03-20.
//


import UIKit

class ItinieraryTableViewController: UITableViewController {
    
    var activities: [Activity]?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return activities?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityList", for: indexPath)

        // Configure the cell...
        
        if let activities = activities {
            let activity = activities[indexPath.row]
            cell.textLabel?.text = activity.title ?? "No activity title"
            cell.detailTextLabel?.text = activity.location ?? "no activity location"
            
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //function to delete item
    private func deleteActivity(at indexPath: IndexPath) {
        
        
        if let activityToDelete = activities?[indexPath.row] {
            context.delete(activityToDelete)
            
            do {
                try context.save()
                activities?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                print("Failed to delete item: \(error.localizedDescription)")
            }
        }
    }
    
    
    //function to edit/update task
    private func updateActivity(activity: Activity, with newTitle: String, newLocation: String) {
    
        
        activity.title = newTitle
        activity.location = newLocation
        
        do {
            try context.save()
            tableView.reloadData()
        } catch {
            print("Failed to update item: \(error.localizedDescription)")
        }
    }
    
    //swipe to delete or edit
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteActivity(at: indexPath)
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") {
            _, indexPath in self.presentEditDialog(for: indexPath)
            
        }
        
        editAction.backgroundColor = .systemBlue
        
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {
            _, indexPath in self.deleteActivity(at: indexPath)
        }
        
        return [editAction, deleteAction]
        
        
        
    }
    
    private func presentEditDialog(for indexPath: IndexPath) {
        guard let activity = activities?[indexPath.row] else {return}
        
        let alert = UIAlertController(title: "Edit Item", message: "Update Item", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = activity.title
        }
        alert.addTextField { textField in
            textField.text = activity.location
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let newTitle = alert.textFields?[0].text, let updatedLocation = alert.textFields?[1].text {
                self.updateActivity(activity: activity, with: newTitle, newLocation: updatedLocation)
            }
        }
        
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
        
    }
}

