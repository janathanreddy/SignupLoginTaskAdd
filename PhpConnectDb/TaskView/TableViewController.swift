//
//  TableViewController.swift
//  PhpConnectDb
//
//  Created by Janarthan Subburaj on 12/02/21.
//

import UIKit
import Alamofire

class TableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var View1: UIView!
    @IBOutlet weak var SearchName: UISearchBar!
    
    var feedItems: NSArray = NSArray()
    var selectedStock : StockModel = StockModel()
    let stock = StockModel()
    var Username:String?
    var mail_Add:String?
    var didselect:String?
    var oldTaskname:String?
    weak var delegate: FeedModelProtocol!
    var buttonAction:String?
    var urlpath:String?
    var Update = [UpdateData]()
    var dateupdate:String?
    var datePicker:UIDatePicker = UIDatePicker()
    var StartDateField1 = UITextField()
    var StartDatePicker1 = UIDatePicker()
    var EndDateField1 = UITextField()
    var EndDatePicker1 = UIDatePicker()
    let toolBar = UIToolbar()
    var StartDateField = UITextField()
    var StartDatePicker = UIDatePicker()
    var EndDateField = UITextField()
    var EndDatePicker = UIDatePicker()
    var didselectStartDate:String?
    var didselectEndDate:String?
    var searching = false
    var searchedname = [UpdateData]()
    var DidSelectAppoint = [DidSelectAppoinment]()
    var dateString:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 40
        View1.layer.cornerRadius = 10
        View1.layer.masksToBounds = true
        SearchName.delegate = self
        downloadItems()
        remainder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let alertController = UIAlertController(title:"Welcome",message:Username,preferredStyle:.alert)
        self.present(alertController,animated:true,completion:{Timer.scheduledTimer(withTimeInterval: 0.5, repeats:false, block: {_ in
            self.dismiss(animated: true, completion: nil)
        })})
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return Update.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let TableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        tableView.rowHeight = 106

            TableViewCell.Task1.text = Update[indexPath.row].TaskName
            TableViewCell.Button.tag = indexPath.row
            TableViewCell.Edit.tag = indexPath.row
            TableViewCell.Button.addTarget(self, action: #selector(CellButton(sender:)), for:.touchUpInside )
            TableViewCell.Edit.addTarget(self, action: #selector(EditButton(sender:)), for:.touchUpInside )
            TableViewCell.StartDate.text = Update[indexPath.row].Start_Date
            TableViewCell.EndDate.text = Update[indexPath.row].End_Date
            
            var ConvertValue = Int(Update[indexPath.row].Remain_Days ?? "")
            if ConvertValue ?? 0 > 0 && Update[indexPath.row].TaskStatus == "Pending"{
                TableViewCell.RemainDays.text = "\(Update[indexPath.row].Remain_Days as! String) Days More"
                TableViewCell.RemainDays.textColor = UIColor.black
            }else if ConvertValue ?? 0 < 0 && Update[indexPath.row].TaskStatus == "Pending"{
                TableViewCell.RemainDays.text = "Task Date Exceeded \((Update[indexPath.row].Remain_Days) as! String)"
                TableViewCell.RemainDays.textColor = UIColor.systemRed
            }else if ConvertValue ?? 0 == 0 && Update[indexPath.row].TaskStatus == "Pending"{
                TableViewCell.RemainDays.text = "Today Last Date "
                TableViewCell.RemainDays.textColor = UIColor.black

            }else if ConvertValue ?? 0 > 0 || ConvertValue ?? 0 == 0 || ConvertValue ?? 0 < 0 && Update[indexPath.row].TaskStatus == "Completed"{
                TableViewCell.RemainDays.text = "Task Completed"
                TableViewCell.RemainDays.textColor = UIColor.systemGreen
            }
            
            if Update[indexPath.row].TaskStatus == "Pending"{
                TableViewCell.Button.setImage(#imageLiteral(resourceName: "check off"), for: .normal)
            }else{
                TableViewCell.Button.setImage(#imageLiteral(resourceName: "check on"), for: .normal)
            }
            return TableViewCell

    }
    
    @IBAction func Add(_ sender: Any) {
       
        var textField = UITextField()
      
                let alert = UIAlertController(title: "Add your Task", message: "", preferredStyle: UIAlertController.Style.alert)
                let action = UIAlertAction(title: "Add", style: UIAlertAction.Style.default) { [self](action) in
                    let alertController = UIAlertController(title: "Task", message: "Task Added", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                    // namo link sever "http://con.test:8888/Task.php"
                    if   textField.text!.trimmingCharacters(in: .whitespaces).isEmpty != true && StartDateField.text!.trimmingCharacters(in: .whitespaces).isEmpty != true && EndDateField.text!.trimmingCharacters(in: .whitespaces).isEmpty != true {
                        let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/Task.php")! as URL)
                        request.httpMethod = "POST"
                        
                        let postString = "username=\(mail_Add as! String)&TaskName=\(textField.text!)&TaskStatus=Pending&date=\(StartDateField.text!)&End_Date=\(EndDateField.text!)"

                        print("postString : \(postString)")

                        request.httpBody = postString.data(using: String.Encoding.utf8)
                        Update.removeAll()
                        searchedname.removeAll()
                        let task = URLSession.shared.dataTask(with: request as URLRequest) {
                            data, response, error in

                            if error != nil {
                                print("error=\(String(describing: error))")
                                return
                            }
                            print("response = \(String(describing: response))")
                            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                            print("responseString = \(String(describing: responseString))")
                            downloadItems()
                        }
                        task.resume()
                        
    //                   Update.append(UpdateData(TaskName: textField.text, TaskStatus: "Pending", Start_Date: StartDateField.text,End_Date: EndDateField.text))
                        self.present(alertController, animated: true, completion: nil)
                        tableView.reloadData()
                    }else{
                        let alert = UIAlertController(title: "Alert", message: "Fill All Fields", preferredStyle: UIAlertController.Style.alert)
                        let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                            }
                        alert.addAction(cancel)
                        present(alert, animated: true, completion: nil)
                    }
           

                    }
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [self](action) ->
                    Void in
                    }
                    alert.addTextField { (alertTextField) in
                      alertTextField.placeholder = "Create new task"
                      textField = alertTextField
                    }
            alert.addTextField { [self] (textField) in
                
                let toolbar=UIToolbar()
                toolbar.sizeToFit()
                self.StartDatePicker = UIDatePicker(frame:CGRect(x: 0, y: self.view.frame.size.height - 220, width:self.view.frame.size.width, height: 50))
                self.StartDatePicker.backgroundColor = UIColor.white
                datePicker.datePickerMode = .date
                let done=UIBarButtonItem(barButtonSystemItem: .done, target:nil, action:#selector(doneselect))
                toolbar.setItems([done], animated: false)
                textField.inputAccessoryView=toolbar
                textField.inputView=StartDatePicker
                textField.placeholder = "Choose Start Task Date"
                StartDatePicker.datePickerMode = .date
                StartDateField = textField

                }
            
            alert.addTextField { [self] (textField) in
                let toolbar=UIToolbar()
                toolbar.sizeToFit()
                self.EndDatePicker = UIDatePicker(frame:CGRect(x: 0, y: self.view.frame.size.height - 220, width:self.view.frame.size.width, height: 50))
                self.EndDatePicker.backgroundColor = UIColor.systemGray6
                datePicker.datePickerMode = .date
                let done=UIBarButtonItem(barButtonSystemItem: .done, target:nil, action:#selector(doneselect1))
                toolbar.setItems([done], animated: false)
                textField.inputAccessoryView=toolbar
                textField.inputView=EndDatePicker
                textField.placeholder = "Choose End Task Date"
                EndDatePicker.datePickerMode = .date
                EndDateField = textField
                }
                alert.addAction(action)
                alert.addAction(cancel)
                present(alert, animated: true, completion: nil)
        
        
    }
    
    @objc func doneselect1(){
        let dateformat=DateFormatter()
        dateformat.dateStyle = .medium
        dateformat.timeStyle = .none
        dateformat.dateFormat = "yyyy-MM-dd"
        let enddateString = dateformat.string(from: EndDatePicker.date)
        EndDateField.text="\(enddateString)"
        self.view.endEditing(true)
    }
        
        @objc func doneselect(){
            let dateformat=DateFormatter()
            dateformat.dateStyle = .medium
            dateformat.timeStyle = .none
            dateformat.dateFormat = "yyyy-MM-dd"
            let datestring = dateformat.string(from: StartDatePicker.date)
            StartDateField.text="\(datestring)"
            self.view.endEditing(true)

        }
    
    @objc func EditButton(sender:UIButton){
        print("Edit Button Tapped")
        let tag = sender.tag
        let indexPath = IndexPath(row: tag, section: 0)
        oldTaskname?.removeAll()
        var textField = UITextField()
        
        didselect = "\(Update[indexPath.row].TaskName as! String)"
        didselectStartDate = "\(Update[indexPath.row].Start_Date as! String)"
        didselectEndDate = "\(Update[indexPath.row].End_Date as! String)"
        print("UpdateFunction \(Int16(Update[indexPath.row].Id as! String) as! Int16)")

        if   textField.text!.trimmingCharacters(in: .whitespaces).isEmpty{

                let alert = UIAlertController(title: "Edit", message: "", preferredStyle: UIAlertController.Style.alert)
                let action = UIAlertAction(title: "update", style: UIAlertAction.Style.default) { [self](action) in
                    let alertController = UIAlertController(title: "Edit", message: "Updation Done", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: nil))
                    
                    // namo link sever "http://con.test:8888/Task.php"
                    
                    let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/Edit.php")! as URL)
                    request.httpMethod = "POST"
                    let postString = "username=\(mail_Add as! String)&TaskName=\(textField.text as! String)&TaskStatus=\(Update[indexPath.row].TaskStatus as! String)&Id=\(Int16(Update[indexPath.row].Id as! String) as! Int16)&date=\(StartDateField1.text!)&End_Date=\(EndDateField1.text!)"
                    print("postString : \(postString)")
                    Update.removeAll()

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
                        downloadItems()

                    }
                    task.resume()
                    
                    self.present(alertController, animated: true, completion: nil)
                    tableView.reloadData()
                    }
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                    }
            
            
            
            
            alert.addTextField { [self] (alertTextField) in
                      alertTextField.placeholder = "Edit Task"
                alertTextField.text = didselect
                      textField = alertTextField
                    }
            
            alert.addTextField { [self] (textField) in
                let toolbar=UIToolbar()
                toolbar.sizeToFit()
            self.StartDatePicker1 = UIDatePicker(frame:CGRect(x: 0, y: self.view.frame.size.height - 220, width:self.view.frame.size.width, height: 50))
            self.StartDatePicker1.backgroundColor = UIColor.white
                datePicker.datePickerMode = .date
                let done=UIBarButtonItem(barButtonSystemItem: .done, target:nil, action:#selector(start))
                toolbar.setItems([done], animated: false)
                textField.inputAccessoryView=toolbar
                textField.inputView=StartDatePicker1
                textField.placeholder = "Edit Start Task Date"
                textField.text = didselectStartDate
                StartDatePicker1.datePickerMode = .date
                StartDateField1 = textField

                }
            
            alert.addTextField { [self] (textField) in
                let toolbar=UIToolbar()

                toolbar.sizeToFit()
                self.EndDatePicker1 = UIDatePicker(frame:CGRect(x: 0, y: self.view.frame.size.height - 220, width:self.view.frame.size.width, height: 50))
                self.EndDatePicker1.backgroundColor = UIColor.systemGray6
                datePicker.datePickerMode = .date
                let done=UIBarButtonItem(barButtonSystemItem: .done, target:nil, action:#selector(end))
                toolbar.setItems([done], animated: false)
                textField.inputAccessoryView=toolbar
                textField.inputView=EndDatePicker1
                textField.text = didselectEndDate
                textField.placeholder = "Edit End Task Date"
                EndDatePicker1.datePickerMode = .date
                EndDateField1 = textField
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
    
    @objc func CellButton(sender:UIButton){
        let tag = sender.tag
            let indexPath = IndexPath(row: tag, section: 0)
            if sender.isSelected{

                sender.isSelected = false
//
                sender.setImage(#imageLiteral(resourceName: "check off"), for: .normal)
// Namo sever Link "http://con.test:8888/update.php"
                let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/update.php")! as URL)
                request.httpMethod = "POST"

                let postString = "TaskName=\(Update[indexPath.row].TaskName as! String)&TaskStatus=Pending"
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
                    print("Checked Deselected")
                }
                task.resume()
            }else{
             
                sender.isSelected = true
                sender.setImage(#imageLiteral(resourceName: "check on"), for: .normal)
                let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/update.php")! as URL)
                request.httpMethod = "POST"
                let postString = "TaskName=\(Update[indexPath.row].TaskName as! String)&TaskStatus=Completed"
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
                    print("Checked Selected")
                    
                }
                task.resume()
             }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

            if editingStyle == .delete {
                // Namo Server Link "http://con.test:8888/delete.php"
                let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/delete.php")! as URL)
                request.httpMethod = "POST"
                print(indexPath.row)
                let postString = "TaskName=\(Update[indexPath.row].TaskName as! String)"

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
                Update.remove(at: indexPath.row)

                tableView.deleteRows(at: [indexPath], with: .fade)

            } else if editingStyle == .insert {
            }
        }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.tableView.reloadData()

    }
//    Namo Server Link "http://con.test:8888/Retrieve_1.php"
//    let urlPath =  "https://appstudio.co/iOS/Retrieve_1.php"
    //Change to the web address of your Retrieve_1.php file
    
    func downloadItems() {
        let postString:String!
        let request = NSMutableURLRequest(url: NSURL(string: urlpath ?? "https://appstudio.co/iOS/Retrieve_1.php")! as URL)
        request.httpMethod = "POST"
            postString = "username=\(mail_Add as! String)"
       

        print("postString \(postString)")

        request.httpBody = postString.data(using: String.Encoding.utf8)

        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in

            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            self.parseJSON(data!)
            print("data : \(data)")
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
                print("jsonResult \(jsonResult.count)")
                jsonElement = jsonResult[i] as! NSDictionary
                let stock = StockModel()
                //the following insures none of the JsonElement values are nil through optional binding
                print("jsonElement \(jsonElement["Id"] as? String) : \(jsonElement["Taskname"] as? String) :  \(jsonElement["TaskStatus"] as? String) : ")
                
                
                if let TaskName = jsonElement["Taskname"] as? String,
                   let TaskStatus = jsonElement["TaskStatus"] as? String,
                   let Id = jsonElement["Id"] as? String,
                   let Start_Date = jsonElement["date"] as? String,
                   let End_Date = jsonElement["End_Date"] as? String,
                   let Remain_Days = jsonElement["Remain_Days"] as? String

                {
                    Update.append(UpdateData(Id: Id,TaskName: TaskName, TaskStatus: TaskStatus,Start_Date: Start_Date,End_Date: End_Date,Remain_Days: Remain_Days))
                    searchedname.append(UpdateData(Id: Id,TaskName: TaskName, TaskStatus: TaskStatus,Start_Date: Start_Date,End_Date: End_Date,Remain_Days: Remain_Days))
                    print("Update : \(Remain_Days) ")
                }
                
                stocks.add(stock)
                
            }
            
        DispatchQueue.main.async(execute: { [self] () -> Void in
            itemsDownloaded(items: stocks)
            })
        }
    
    @IBAction func logout(_ sender: Any) {
        let parameters: Parameters=["logout":"logout"]
        AF.request("https://appstudio.co/iOS/logout.php", method: .get, parameters: parameters).responseJSON
        {[self]Response in
            if let result = Response.value{
                let jsonData = result as! NSDictionary
                print("jsonData : \(jsonData.allValues)")

                for i in jsonData.allValues{
                    print("Response Status : \(i)")
                    if i as! String == "Success"{
                        performSegue(withIdentifier: "Logout", sender: self)
                    }else{
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
    
    @IBAction func Refresh(_ sender: Any) {
        Update.removeAll()
        downloadItems()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        didselect?.removeAll()

            oldTaskname?.removeAll()
            var textField = UITextField()
            
            didselect = "\(Update[indexPath.row].TaskName as! String)"
            didselectStartDate = "\(Update[indexPath.row].Start_Date as! String)"
            didselectEndDate = "\(Update[indexPath.row].End_Date as! String)"

            if   textField.text!.trimmingCharacters(in: .whitespaces).isEmpty{

                    let alert = UIAlertController(title: "Edit", message: "", preferredStyle: UIAlertController.Style.alert)
                    let action = UIAlertAction(title: "update", style: UIAlertAction.Style.default) { [self](action) in
                        let alertController = UIAlertController(title: "Edit", message: "Updation Done", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: nil))
                        
                        // namo link sever "http://con.test:8888/Task.php"
                        
                        let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/Edit.php")! as URL)
                        request.httpMethod = "POST"
                        let postString = "username=\(mail_Add as! String)&TaskName=\(textField.text as! String)&TaskStatus=\(Update[indexPath.row].TaskStatus as! String)&Id=\(Int16(Update[indexPath.row].Id as! String) as! Int16)&date=\(StartDateField1.text!)&End_Date=\(EndDateField1.text!)"
                        print("postString : \(postString)")
                        Update.removeAll()
                        searchedname.removeAll()
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
                            downloadItems()

                        }
                        task.resume()
                        
                        self.present(alertController, animated: true, completion: nil)
                        tableView.reloadData()
                        }
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                        }
                
                
                
                
                alert.addTextField { [self] (alertTextField) in
                          alertTextField.placeholder = "Edit Task"
                    alertTextField.text = didselect
                          textField = alertTextField
                        }
                
                alert.addTextField { [self] (textField) in
                    let toolbar=UIToolbar()
                    toolbar.sizeToFit()
                self.StartDatePicker1 = UIDatePicker(frame:CGRect(x: 0, y: self.view.frame.size.height - 220, width:self.view.frame.size.width, height: 50))
                self.StartDatePicker1.backgroundColor = UIColor.white
                    datePicker.datePickerMode = .date
                    let done=UIBarButtonItem(barButtonSystemItem: .done, target:nil, action:#selector(start))
                    toolbar.setItems([done], animated: false)
                    textField.inputAccessoryView=toolbar
                    textField.inputView=StartDatePicker1
                    textField.placeholder = "Edit Start Task Date"
                    textField.text = didselectStartDate
                    StartDatePicker1.datePickerMode = .date
                    StartDateField1 = textField

                    }
                
                alert.addTextField { [self] (textField) in
                    let toolbar=UIToolbar()

                    toolbar.sizeToFit()
                    self.EndDatePicker1 = UIDatePicker(frame:CGRect(x: 0, y: self.view.frame.size.height - 220, width:self.view.frame.size.width, height: 50))
                    self.EndDatePicker1.backgroundColor = UIColor.systemGray6
                    datePicker.datePickerMode = .date
                    let done=UIBarButtonItem(barButtonSystemItem: .done, target:nil, action:#selector(end))
                    toolbar.setItems([done], animated: false)
                    textField.inputAccessoryView=toolbar
                    textField.inputView=EndDatePicker1
                    textField.text = didselectEndDate
                    textField.placeholder = "Edit End Task Date"
                    EndDatePicker1.datePickerMode = .date
                    EndDateField1 = textField
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
    
    @objc func start(){
        let dateformat=DateFormatter()
        dateformat.dateStyle = .medium
        dateformat.timeStyle = .none
        dateformat.dateFormat = "yyyy-MM-dd"
        let datestring = dateformat.string(from: StartDatePicker1.date)
        StartDateField1.text="\(datestring as! String)"
        self.view.endEditing(true)

    }
        
        @objc func end(){
            let dateformat=DateFormatter()
            dateformat.dateStyle = .medium
            dateformat.timeStyle = .none
            dateformat.dateFormat = "yyyy-MM-dd"
            let enddateString = dateformat.string(from: EndDatePicker1.date)
            EndDateField1.text="\(enddateString as! String)"
            self.view.endEditing(true)

        }

    
    @IBAction func Filter(_ sender: Any) {
        if View1.isHidden == false{
            View1.isHidden = true
        }else if View1.isHidden == true{
            View1.isHidden = false
        }
    }
    
    @IBAction func AllTasks(_ sender: Any) {
        buttonAction?.removeAll()
        urlpath?.removeAll()
        Update.removeAll()
        searchedname.removeAll()
        buttonAction = "AllTasks"
        urlpath = "https://appstudio.co/iOS/Retrieve_1.php"
        View1.isHidden = true
        downloadItems()
        tableView.reloadData()
        View1.isHidden = true
    }
    
    @IBAction func Completed(_ sender: Any) {
        buttonAction?.removeAll()
        urlpath?.removeAll()
        Update.removeAll()
        searchedname.removeAll()
        buttonAction = "Completed"
        urlpath = "https://appstudio.co/iOS/Completed.php"
        View1.isHidden = true
        downloadItems()
        tableView.reloadData()
    }
    
    @IBAction func Pending(_ sender: Any) {
        buttonAction?.removeAll()
        urlpath?.removeAll()
        Update.removeAll()
        searchedname.removeAll()
        buttonAction = "Pending"
        urlpath = "https://appstudio.co/iOS/Pending.php"
        View1.isHidden = true
        downloadItems()
        tableView.reloadData()
    }
    
    @IBAction func Today(_ sender: Any) {
        urlpath?.removeAll()
        buttonAction?.removeAll()
        Update.removeAll()
        searchedname.removeAll()
        urlpath = "https://appstudio.co/iOS/Today.php"
        buttonAction = "Today"
        View1.isHidden = true
        downloadItems()
        tableView.reloadData()
    }
    
    @IBAction func Past(_ sender: Any) {
        buttonAction?.removeAll()
        urlpath?.removeAll()
        Update.removeAll()
        searchedname.removeAll()
        urlpath = "https://appstudio.co/iOS/past.php"
        buttonAction = "Past"
        View1.isHidden = true
        downloadItems()
        tableView.reloadData()
    }
    
    @IBAction func Tomorrow(_ sender: Any) {
        buttonAction?.removeAll()
        urlpath?.removeAll()
        Update.removeAll()
        searchedname.removeAll()
        urlpath = "https://appstudio.co/iOS/Tomorrow.php"
        buttonAction = "Tomorrow"
        View1.isHidden = true
        downloadItems()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        SearchName.resignFirstResponder()
    }
    @IBAction func Searchbtn(_ sender: Any) {
        SearchName.isHidden = false
    }
    
}
extension TableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        SearchName.showsCancelButton = true
//        searchedname = Update.filter({$0.TaskName!.contains(searchText)})
        guard !searchText.isEmpty else{
         Update = searchedname
          tableView.reloadData()
          return
         }
         Update = searchedname.filter({ UpdateData -> Bool in
            UpdateData.TaskName!.contains(searchText)
         })
         tableView.reloadData()
          
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        SearchName.text = ""
        SearchName.showsCancelButton = false
        SearchName.isHidden = true
        tableView.reloadData()
    }
    
    func remainder(){
        
        print("dateString : \(dateString)")
        let Content = UNMutableNotificationContent()
          Content.title = "Alert!"
          Content.subtitle = "Task remaninder"
          Content.body = "Pls check today's task, its a last day!!"
          let Trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
          let RequestIdentifier = "check"
          let request = UNNotificationRequest(identifier: RequestIdentifier, content: Content, trigger: Trigger)
          UNUserNotificationCenter.current().add(request) { (error) in
                print(error as Any)
          }
    }
}
struct UpdateData {
    var Id:String?
    var TaskName:String?
    var TaskStatus:String?
    var Start_Date:String?
    var End_Date:String?
    var Remain_Days:String?
    var Total_Days:String?
    
}

class DidSelectAppoinment {
    var Id:String?
    var TaskName:String?
    var TaskStatus:String?
    var Start_Date:String?
    var End_Date:String?
    var Remain_Days:String?
    var Total_Days:String?
    
}

