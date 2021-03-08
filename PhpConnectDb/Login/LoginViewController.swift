//
//  LoginViewController.swift
//  PhpConnectDb
//
//  Created by Janarthan Subburaj on 12/02/21.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var LeftContraints: NSLayoutConstraint!
    @IBOutlet weak var Cloud: UIImageView!
    @IBOutlet weak var LoginBtn: UIButton!
    @IBOutlet weak var View1: UIView!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var EmailLog: UITextField!
    @IBOutlet weak var activityindicator: UIActivityIndicatorView!
    
    var Username:String?
    var mail_add:String?
    var Name:String?
    var Email:String?
    var Passwords:String?
    var checkuser:String?
//    namo server link "http://con.test:8888/login.php"
    let urlPath = "https://appstudio.co/iOS/login.php" //Change to the web address of your loginretrieve.php file
    let defaultValues = UserDefaults.standard
    var feedItems: NSArray = NSArray()
    var checfield:String?
    var LoginStatus:Bool?
    var LoginVerify = [LoginDetails]()
        override func viewDidLoad() {
        super.viewDidLoad()
            View1.layer.cornerRadius = 10
            View1.layer.masksToBounds = true
            animateClouds()
            LoginBtn.layer.cornerRadius = 5
            LoginBtn.layer.masksToBounds = true
            activityindicator.isHidden = true
    }
    
    
    @IBAction func Login(_ sender: Any) {
        let parameters: Parameters=[
                    "username":EmailLog.text!,
                    "password":Password.text!
                ]
        activityindicator.isHidden = false
        activityindicator.startAnimating()
        print("checkuser : \(checkuser)")
        if !EmailLog.text!.trimmingCharacters(in: .whitespaces).isEmpty && !Password.text!.trimmingCharacters(in: .whitespaces).isEmpty{
            AF.request(urlPath, method: .post, parameters: parameters).responseJSON
            {[self]Response in
                if let result = Response.value{
                    let jsonData = result as! NSDictionary
                    print("jsonData : \(jsonData.allValues)")

                    for i in jsonData.allValues{
                        if i as! String == "success"{
                                if EmailLog.text == "admin@admin.com"{
                                    mail_add = EmailLog.text
                                    EmailLog.text = ""
                                    Password.text = ""
                                    activityindicator.stopAnimating()
                                    activityindicator.isHidden = true
                                    performSegue(withIdentifier: "AdminLogin", sender: self)
                                }else{
                                    mail_add = EmailLog.text
                                    EmailLog.text = ""
                                    Password.text = ""
                                    activityindicator.stopAnimating()
                                    activityindicator.isHidden = true
                                    performSegue(withIdentifier: "Task", sender: self)
                                }
                        
                        }else if i as! String == "failure"{
                            activityindicator.stopAnimating()
                            activityindicator.isHidden = true
                            let alert = UIAlertController(title: "Alert", message: "Check Username and Password", preferredStyle: UIAlertController.Style.alert)
                            let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                                }
                            alert.addAction(cancel)
                            present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
            
                
            }else{
                activityindicator.stopAnimating()
                activityindicator.isHidden = true
            let alert = UIAlertController(title: "Alert", message: "Fill All Fields", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                }
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
}
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Task"{
            if let viewController: TableViewController = segue.destination as? TableViewController {
                viewController.mail_Add = mail_add
             }
        }
    }
    
    private func animateClouds() {
        LeftContraints.constant = 0
        Cloud.layer.removeAllAnimations()
      view.layoutIfNeeded()
      let distance = view.bounds.width - Cloud.bounds.width
      self.LeftContraints.constant = distance
        UIView.animate(withDuration: 15, delay: 0, options: [.repeat, .autoreverse], animations: {
       self.view.layoutIfNeeded()
      })
     }
}

struct LoginDetails{
    var name:String?
    var emailId:String?
    var passwordId:String?
}



/*
 func requestPost () {
     var request = URLRequest(url: URL(string: "https://appstudio.co/iOS/login.php")!)
     request.httpMethod = "POST"
     let postString = "username=\(userText.text as! String)&password=\(passText.text as! String)"
     request.httpBody = postString.data(using: .utf8)
     let task = URLSession.shared.dataTask(with: request) { data, response, error in
       guard let data = data, error == nil else {
         print("error=\(error)")
         return
       }
       if let array = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [[String:Any]],
         let obj = array.first {
          let username = obj["username"] as? String
            let pass = obj["password"] as? String
          DispatchQueue.main.async {
           self.log.username = username
           self.log.password = pass
          }}}
       task.resume()
       }


 Message shaahid















*/
