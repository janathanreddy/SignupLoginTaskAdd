//
//  UserViewController.swift
//  PhpConnectDb
//
//  Created by Janarthan Subburaj on 24/02/21.
//

import UIKit

class UserViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    

    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var name:String?
    var username:String?
    var userTask = [userTasks]()
    var feedItems: NSArray = NSArray()
    var selectedStock : StockModel = StockModel()
    let stock = StockModel()
    var didselect:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        view1.layer.cornerRadius = 10
        let shadowPath = UIBezierPath(rect: view.bounds)
        view1.layer.masksToBounds = true
        view1.layer.shadowColor = UIColor.systemIndigo.cgColor
        view1.layer.shadowOpacity = 0.2
        tableView.delegate = self
        tableView.dataSource = self
        nameLabel.text = name
        downloadItems()
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

            if editingStyle == .delete {
// Namo Server Link "http://con.test:8888/delete.php"
                let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/delete.php")! as URL)
                request.httpMethod = "POST"
                print(indexPath.row)
                let postString = "TaskName=\(userTask[indexPath.row].TaskName as! String)"

                print("postString \(postString)")

                request.httpBody = postString.data(using: String.Encoding.utf8)

                let task = URLSession.shared.dataTask(with: request as URLRequest) {
                    data, response, error in

                    if error != nil {
                        print("error=\(String(describing: error))")
                        return
                    }

                    print("response = \(String(describing: response))")

                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("responseString = \(String(describing: responseString))")

                }
                task.resume()
                userTask.remove(at: indexPath.row)

                tableView.deleteRows(at: [indexPath], with: .fade)

            } else if editingStyle == .insert {
            }
        }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let UserTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        UserTableViewCell.TaskName.text = userTask[indexPath.row].TaskName
        UserTableViewCell.TaskStatus.text = userTask[indexPath.row].TaskStatus
        return UserTableViewCell
    }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.tableView.reloadData()

    }
    
    func downloadItems() {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/Retrieve_1.php")! as URL)
        request.httpMethod = "POST"
        let postString = "username=\(username as! String)"

        print("postString \(postString)")

        request.httpBody = postString.data(using: String.Encoding.utf8)

        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in

            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            self.parseJSON(data!)
            print("response = \(String(describing: response))")

            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")

        }
        task.resume()
    }
    
    func parseJSON(_ data:Data) {
            
            var jsonResult = NSArray()
            
            do{
                jsonResult = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.allowFragments) as! NSArray
                
            } catch let error as NSError {
                print(error)
                
            }
            
            var jsonElement = NSDictionary()
            let stocks = NSMutableArray()
            
            for i in 0 ..< jsonResult.count
            {
                
                jsonElement = jsonResult[i] as! NSDictionary
                
                let stock = StockModel()
                
                //the following insures none of the JsonElement values are nil through optional binding
                print("jsonElement \(jsonElement["Id"] as? String)")
                if let TaskName = jsonElement["Taskname"] as? String,
                   let TaskStatus = jsonElement["TaskStatus"] as? String,let Id = jsonElement["Id"] as? String
                {
                    userTask.append(userTasks(TaskName: TaskName, TaskStatus: TaskStatus, Id: Id))
                }
                
                stocks.add(stock)
                
            }
            
        DispatchQueue.main.async(execute: { [self] () -> Void in
            itemsDownloaded(items: stocks)
            })
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didselect?.removeAll()
        var textField = UITextField()
        didselect = "\(userTask[indexPath.row].TaskName as! String)"
        print("UpdateFunction \(Int16(userTask[indexPath.row].Id as! String) as! Int16)")
        if   textField.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            userTask.removeAll()
            downloadItems()

                let alert = UIAlertController(title: "Edit", message: "", preferredStyle: UIAlertController.Style.alert)
                let action = UIAlertAction(title: "update", style: UIAlertAction.Style.default) { [self](action) in
                    let alertController = UIAlertController(title: "Edit", message: "Updation Done", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: nil))
                    
                    // namo link sever "http://con.test:8888/Task.php"
                    
                    let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/Edit.php")! as URL)
                    request.httpMethod = "POST"
                    let postString = "username=\(username as! String)&TaskName=\(textField.text as! String)&TaskStatus=\(userTask[indexPath.row].TaskStatus as! String)&Id=\(Int16(userTask[indexPath.row].Id as! String) as! Int16)"
                    print("postString : \(postString)")

                    request.httpBody = postString.data(using: String.Encoding.utf8)

                    let task = URLSession.shared.dataTask(with: request as URLRequest) {
                        data, response, error in

                        if error != nil {
                            print("error=\(String(describing: error))")
                            return
                        }
                        print("response = \(String(describing: response))")
                        let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                        print("responseString = \(String(describing: responseString))")
                    }
                    task.resume()
                    
                    self.present(alertController, animated: true, completion: nil)
                    userTask.removeAll()
                    downloadItems()
                    tableView.reloadData()
                    }
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                    }
            alert.addTextField { [self] (alertTextField) in
                      alertTextField.placeholder = "Edit Task"
                alertTextField.text = didselect
                      textField = alertTextField
                    }
                    alert.addAction(action)
            alert.addAction(cancel)
                    present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Alert", message: "Fill All Fields", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                }
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }

    }
}

struct userTasks {
    var TaskName:String!
    var TaskStatus:String!
    var Id:String!
}
