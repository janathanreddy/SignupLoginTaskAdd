//
//  ViewController.swift
//  PhpConnectDb
//
//  Created by Janarthan Subburaj on 12/02/21.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var LeftConstraints: NSLayoutConstraint!
    @IBOutlet weak var Cloud: UIImageView!
    @IBOutlet weak var RegisterBtn: UIButton!
    @IBOutlet weak var View1: UIView!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Name: UITextField!
    
    var feedItems: NSArray = NSArray()
    var Username:String?
    var mail_Add:String?
    var Signup = [SignupDetails]()
    var exist:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        View1.layer.cornerRadius = 10
        View1.layer.masksToBounds = true
        animateClouds()
        RegisterBtn.layer.cornerRadius = 5
        RegisterBtn.layer.masksToBounds = true
        downloadItems()
    }

    @IBAction func Register(_ sender: Any) {
        exist?.removeAll()
        Verify()
        if  !Name.text!.trimmingCharacters(in: .whitespaces).isEmpty && !Email.text!.trimmingCharacters(in: .whitespaces).isEmpty && !Password.text!.trimmingCharacters(in: .whitespaces).isEmpty  {
            if exist != "Matching"{
                // namo server link "http://con.test:8888/orgReg.php"
                let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/orgReg.php")! as URL)
                request.httpMethod = "POST"
                let postString = "name=\(Name.text!)&username=\(Email.text!)&password=\(Password.text!)"
                Username = Name.text
                mail_Add =  Email.text
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
                performSegue(withIdentifier: "Task1", sender: self)

                Name.text = ""
                Email.text = ""
                Password.text = ""
            }else{
                let alert = UIAlertController(title: "Alert", message: "User Already Exist", preferredStyle: UIAlertController.Style.alert)
                let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                    }
                alert.addAction(cancel)
                present(alert, animated: true, completion: nil)
                Name.text = ""
                Email.text = ""
                Password.text = ""
            }
        
        }else{
            let alert = UIAlertController(title: "Alert", message: "Fill All Fields", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                }
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            Name.text = ""
            Email.text = ""
            Password.text = ""
        }
    }
    
    func Verify(){
        for Verified in Signup{
        print("Verified : \(Verified)")
            if Verified.username as! String == Email.text as! String{
                exist = "Matching"
                print("Verify : \(Verified.name) \(Email.text as! String)")
            }
        }
    }
    
    private func animateClouds() {
        LeftConstraints.constant = 0
        Cloud.layer.removeAllAnimations()
      view.layoutIfNeeded()
      let distance = view.bounds.width - Cloud.bounds.width
      self.LeftConstraints.constant = distance
        UIView.animate(withDuration: 15, delay: 0, options: [.repeat, .autoreverse], animations: {
       self.view.layoutIfNeeded()
      })
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Task1"{
            if let viewController: TableViewController = segue.destination as? TableViewController {
                viewController.Username = Username
                viewController.mail_Add = mail_Add
             }
        }
    }
    
    func downloadItems() {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://appstudio.co/iOS/login1.php")! as URL)
        request.httpMethod = "POST"
        let postString = "username=\(Email.text as! String)"

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
                
                if let name = jsonElement["name"] as? String,
                    let username = jsonElement["username"] as? String,let password = jsonElement["password"] as? String
                {
                    Signup.append(SignupDetails(name: name, username: username, password: password))
                    print("Signup : \(Signup)")
                }
                
                stocks.add(stock)
                
            }
            
        DispatchQueue.main.async(execute: { [self] () -> Void in
            itemsDownloaded(items: stocks)
            })
        }
    
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
    }
}

struct SignupDetails{
    var name:String?
    var username:String?
    var password:String?
}
