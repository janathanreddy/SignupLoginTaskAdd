//
//  AdminViewController.swift
//  PhpConnectDb
//
//  Created by Janarthan Subburaj on 20/02/21.
//

import UIKit
import Alamofire

class AdminViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var feedItems: NSArray = NSArray()
    var selectedStock : StockModel = StockModel()
    let stock = StockModel()
    var pickerView = UIPickerView()
    var names:[String] = []
    var didselect:Bool = false
    var namelist:[String] = []
    var keyvalue:[String:String] = [:]
    var pendingcount:[String:String] = [:]
    var completedcount:[String:String] = [:]
    var pendintasks:[String] = []
    var selectedname:String?
    var selectedusername:String?
    
    var nameArray =  [String]()
    var StatusArray = [String]()
    var Admin = [AdminRetrieve]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ExpandCell", bundle: nil), forCellReuseIdentifier: "ExpandCell")
        downloadItems()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        downloadItems()
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyvalue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let AdminTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AdminTableViewCell", for: indexPath) as! AdminTableViewCell
        for (keys,values) in pendingcount{
            if Admin[indexPath.row].username == keys{
                AdminTableViewCell.PendingLabel.text = "Pending \(pendintasks[indexPath.row] as! String)"
                print("pendingcount \(Admin[indexPath.row].counttask)")
            }
        }
        for (keys,values) in completedcount{
            if Admin[indexPath.row].username == keys{
                AdminTableViewCell.CompletedLabel.text = "Completed \(Admin[indexPath.row].counttask as! String)"
                print("completedcount \(Admin[indexPath.row].counttask)")
            }

        }
        for (keys,values) in keyvalue{
            if Admin[indexPath.row].username == keys{
                AdminTableViewCell.NameLabel.text = Admin[indexPath.row].name
            }
        }
        
        return AdminTableViewCell
    }
    
    @IBAction func Logout(_ sender: Any) {
        let parameters: Parameters=["logout":"logout"]
        AF.request("https://appstudio.co/iOS/logout.php", method: .get, parameters: parameters).responseJSON
        {[self]Response in
            if let result = Response.value{
                let jsonData = result as! NSDictionary
                print("jsonData : \(jsonData.allValues)")

                for i in jsonData.allValues{
                    print("Response Status : \(i)")
                    if i as! String == "Success"{
                        performSegue(withIdentifier: "AdminLogout", sender: self)                    }else{
                    let alert = UIAlertController(title: "Alert", message: "Logout Failed", preferredStyle: UIAlertController.Style.alert)
                    let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                        }
                    alert.addAction(cancel)
                    present(alert, animated: true, completion: nil)
                    }
                }
                
            }
        }
    }
   
  
    
    @IBAction func AddTask(_ sender: Any) {
        
        performSegue(withIdentifier: "AddTaskPopUp", sender: self)
    }
    @IBAction func Refresh(_ sender: Any) {
        print("Refresh Tapped")
        Admin.removeAll()
        downloadItems()
        tableView.reloadData()
    }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.tableView.reloadData()

    }
//    Namo Server Link "http://con.test:8888/Retrieve_1.php"
    let urlPath =  "https://appstudio.co/iOS/Admin.php"
//   Change to the web address of your Retrieve_1.php file
    
    func downloadItems() {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/Admin.php")! as URL)
        request.httpMethod = "POST"
        let postString = "username=\("admin@admin.com" as! String)"

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
//            print("responseString = \(String(describing: responseString))")

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
                print("jsonElement : \(jsonElement)")
                let stock = StockModel()
                print("\(jsonElement["CountTask"] as? String) : \(jsonElement["TaskStatus"] as! String)")
                
                if jsonElement["TaskStatus"] as? String == "Completed"{
                    completedcount.updateValue(jsonElement["TaskStatus"] as! String, forKey: jsonElement["username"] as! String)
                    

                }else{
                    print("*** Pending : \(jsonElement["CountTask"] as! String) : \(jsonElement["TaskStatus"] as! String) ***")
                    pendingcount.updateValue(jsonElement["TaskStatus"] as! String, forKey: jsonElement["username"] as! String)
                    pendintasks.append(jsonElement["CountTask"] as! String)
                    
                }
                if let name = jsonElement["name"] as? String,
                   let TaskStatus = jsonElement["TaskStatus"] as? String,
                   let taskcount = jsonElement["CountTask"] as? String,
                   let username = jsonElement["username"] as? String
                {
                    Admin.append(AdminRetrieve(name: name,username: username,counttask: taskcount))
                    keyvalue.updateValue(jsonElement["name"] as! String, forKey: jsonElement["username"] as! String)
                }
                stocks.add(stock)
            }
        let groupByCategory = Dictionary(grouping: Admin) { (device) -> String in
            return device.name!
        }
        namelist.append(contentsOf: groupByCategory.keys)
        DispatchQueue.main.async(execute: { [self] () -> Void in
            itemsDownloaded(items: stocks)
            })
        }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("AdminRetrieve : \(Admin[indexPath.row].username)")
        didselect = true
        selectedname = Admin[indexPath.row].name as! String
        selectedusername = Admin[indexPath.row].username as! String
        performSegue(withIdentifier: "userDetails", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "userDetails"{
            if let viewController: UserViewController = segue.destination as? UserViewController {
                viewController.name = selectedname
                viewController.username = selectedusername
             }
        }
    }
    
}

struct AdminRetrieve {
    var name:String?
    var username:String?
    var counttask:String?
    var pendingtask:String?
}
