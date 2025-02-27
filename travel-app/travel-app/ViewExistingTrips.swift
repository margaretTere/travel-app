import UIKit

class ViewExistingTrips: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    
    @IBOutlet weak var tripsView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tripsView.dataSource = self
        tripsView.delegate = self
    }

    func tableView(_ tripsView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tripsView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tripsView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        cell.textLabel?.text = "Trip \(indexPath.row + 1)"
        return cell
    }

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tripCell")
//    }

}

