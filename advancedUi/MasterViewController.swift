import UIKit

var objects: [[String:Any]] = [];

extension UITableView {
    func refreshTable(){
        let indexPathForSection = NSIndexSet(index: 0)
        self.reloadSections(indexPathForSection as IndexSet, with: UITableViewRowAnimation.middle)
    }
}

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil
    var albumPtr: Int = 0;
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        if(objects.count == 0){
            self.consumeJson()
        }
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.insertNewObject(_:)))
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async{
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
    
        self.tableView.reloadData()
        super.viewWillAppear(animated)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func insertNewObject(_ sender: Any) {
        var tab = [String: Any]()
        tab["artist"] = ""
        tab["album"] = ""
        tab["genre"] = ""
        tab["year"] = ""
        tab["tracks"] = ""
        objects.insert(tab, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .automatic)
        performSegue(withIdentifier: "todetail", sender: self)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! [String:Any]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ViewControllerTableViewCell
        let object = objects[indexPath.row]
        print("view")
        cell.lab1.text = (object["artist"] as! String)
        cell.lab2.text = (object["album"] as! String)
        cell.lab3.text = String(describing: (object["year"])!)
        
        print("OBJECT HERE \(object["album"]!)")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func consumeJson() {
        let urlToResource: String = "https://isebi.net/albums.php"
        guard let url = URL(string: urlToResource) else {
            print("Error: cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler:
            { (data: Data?, response: URLResponse?, error: Error?) in
                if let response = response {
                    print(response)
                }
                if let error = error {
                    print(error)
                }
                print("Data \(data)")
                do {
                    guard let albumJson = try JSONSerialization.jsonObject(with: data!, options: [])
                        as? [[String:Any]] else {
                            print("error during convert data to JSON")
                            return
                    }
                    objects = albumJson
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print("Album is: \(objects)")
                
                } catch  {
                    print("error during convert data to JSON")
                    return
                }
        })
        
        task.resume()
        
        
    }
    
    
}
