//
//  PopUpViewController.swift
//  PhpConnectDb
//
//  Created by Janarthan Subburaj on 23/02/21.
//

import UIKit

class PopUpViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   

    @IBOutlet weak var View1: UIView!
    @IBOutlet weak var CancelBtn: UIButton!
    @IBOutlet weak var Addbtn: UIButton!
    @IBOutlet weak var ChooseName: UITextField!
    @IBOutlet weak var AddTaskText: UITextField!
    @IBOutlet weak var ChooseDate: UITextField!
    @IBOutlet weak var End_Date: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var feedItems: NSArray = NSArray()
    var selectedStock : StockModel = StockModel()
    let stock = StockModel()
    var proofs:[String] = []
    var proof = [retrieveProof]()
    var namelist:[String:String] = [:]
    var usernames:[String] = []
    var Selected:[String] = []
    var setstring:Set<String> = []
    var selectednames:[String] = []
    var start_end_date = UIDatePicker()
    var End_Date_Task = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        View1.layer.cornerRadius = 10
        Addbtn.layer.cornerRadius = 5
        CancelBtn.layer.cornerRadius = 5
        let shadowPath = UIBezierPath(rect: view.bounds)
        View1.layer.masksToBounds = false
        View1.layer.shadowColor = UIColor.systemIndigo.cgColor
        View1.layer.shadowOpacity = 0.2
        tableView.layer.borderColor = UIColor.systemBlue.cgColor
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 10
        datepickerbirth()
        doneselect()
        datepickerbirth1()
        doneselect1()
        
        downloadItems() 
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.tableView.isHidden = true
    }
    @objc func datepickerbirth(){
            let toolbar=UIToolbar()
            toolbar.sizeToFit()
            let done=UIBarButtonItem(barButtonSystemItem: .done, target:nil, action:#selector(doneselect))
            toolbar.setItems([done], animated: false)
            ChooseDate.inputAccessoryView=toolbar
            ChooseDate.inputView=start_end_date
            start_end_date.datePickerMode = .date
        }
        
        @objc func doneselect(){
            let dateformat=DateFormatter()
            dateformat.dateStyle = .medium
            dateformat.timeStyle = .none
            dateformat.dateFormat = "yyyy-MM-dd"
            let datestring = dateformat.string(from: start_end_date.date)
            ChooseDate.text="\(datestring)"
            self.view.endEditing(true)
        }
    @objc func datepickerbirth1(){
            let toolbar=UIToolbar()
            toolbar.sizeToFit()
            let done=UIBarButtonItem(barButtonSystemItem: .done, target:nil, action:#selector(doneselect1))
            toolbar.setItems([done], animated: false)
            End_Date.inputAccessoryView=toolbar
            End_Date.inputView=End_Date_Task
            End_Date_Task.datePickerMode = .date
        }
        
        @objc func doneselect1(){
            let dateformat=DateFormatter()
            dateformat.dateStyle = .medium
            dateformat.timeStyle = .none
            dateformat.dateFormat = "yyyy-MM-dd"
            let datestring = dateformat.string(from: End_Date_Task.date)
            End_Date.text="\(datestring)"
            self.view.endEditing(true)
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namelist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ChooseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ChooseTableViewCell", for: indexPath) as! ChooseTableViewCell
        for (keys,values) in namelist{
            if usernames[indexPath.row] == keys{
                print("keys : \(keys)")
                ChooseTableViewCell.NameLabel.text = values
            }
            
        }
        ChooseTableViewCell.ChooseBtn.tag = indexPath.row
        ChooseTableViewCell.ChooseBtn.addTarget(self, action: #selector(CellButton(sender:)), for:.touchUpInside )
        return ChooseTableViewCell
    }
    
    @IBAction func CancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddAction(_ sender: Any) {
        
        for i in Selected{
            print("i : \(i)")
            let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/Task.php")! as URL)
            request.httpMethod = "POST"
            let postString = "End_Date=\(End_Date.text!)&date=\(ChooseDate.text!)&username=\(i as! String)&TaskName=\(AddTaskText.text!)&TaskStatus=Pending"

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
        }
        View1.isHidden = true
        tableView.isHidden = true
        let alertController = UIAlertController(title:"New task",message:"Task Assigned Successfully",preferredStyle:.alert)
            self.present(alertController,animated:true,completion:{Timer.scheduledTimer(withTimeInterval: 0.20, repeats:false, block: {_ in
                self.dismiss(animated: true, completion: nil)
            })})
            dismiss(animated: true, completion: nil)
        
        }
    
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
                if let name = jsonElement["name"] as? String,
                   let username = jsonElement["username"] as? String
                {
                    proof.append(retrieveProof(name: name,username: username))
                    usernames.append(jsonElement["username"] as! String)
                    setstring.contains(jsonElement["username"] as! String)
                    namelist.updateValue("\(jsonElement["name"] as! String)", forKey: "\(jsonElement["username"] as! String)")
                }
                
                stocks.add(stock)
                
            }
        let groupByCategory = Dictionary(grouping: proof) { (device) -> String in
                return device.name!
            }
            proofs.append(contentsOf: groupByCategory.keys)
        print("setstring: \(setstring)")
        print("usernames: \(usernames)")
        print("namelist : \(namelist)")
        DispatchQueue.main.async(execute: { [self] () -> Void in
            itemsDownloaded(items: stocks)
            })
        }
    

    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.tableView.reloadData()

    }
    
    @IBAction func TableViewOpen(_ sender: Any) {
        tableView.isHidden = false
    }
    
    @objc func CellButton(sender:UIButton){
        let tag = sender.tag
        let indexPath = IndexPath(row: tag, section: 0)
        if sender.isSelected{
            sender.isSelected = false
            sender.setImage(UIImage(systemName: "circle"), for: .normal)
            Selected = Selected.filter() { $0 != "\(proof[indexPath.row].username as! String)"}
            selectednames = selectednames.filter() { $0 != "\(proof[indexPath.row].name as! String)"}

            print("Deselected :  \(Selected) \(selectednames)")
           
        }else{
            sender.isSelected = true
            sender.setImage(UIImage(systemName: "circle.fill"), for: .normal)
            Selected.append("\(proof[indexPath.row].username as! String)")
            print("Selected : \(Selected)")
            selectednames.append("\(proof[indexPath.row].name as! String)")
            print("selected :  \(Selected) \(selectednames)")

    }
        
        
    
}
}
struct retrieveProof{
    var name:String!
    var username:String!
}
