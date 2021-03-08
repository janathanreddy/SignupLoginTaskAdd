//
//  FeedModel.swift
//  PhpConnectDb
//
//  Created by Janarthan Subburaj on 16/02/21.
//

import Foundation
protocol FeedModelProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class FeedModel: NSObject, URLSessionDataDelegate {
    
    
    
    weak var delegate: FeedModelProtocol!
    
    let urlPath = "http://localhost:8888/Retrieve_1.php" //Change to the web address of your Retrieve_1.php file
    
    func downloadItems() {
        
        let url: URL = URL(string: urlPath)!
        let defaultSession = Foundation.URLSession(configuration: URLSessionConfiguration.default)
        
        let task = defaultSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("Error")
            }else {
                print("stocks downloaded")
                self.parseJSON(data!)
            }
            
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
                if let TaskName = jsonElement["TaskName"] as? String,
                    let TaskStatus = jsonElement["TaskStatus"] as? String
            
                {
                    print(TaskName)
                    print(TaskStatus)
                    stock.TaskName = TaskName
                    stock.TaskStatus = TaskStatus
                   
                    
                }
                
                stocks.add(stock)
                
            }
            
        DispatchQueue.main.async(execute: { [self] () -> Void in
                
            delegate.itemsDownloaded(items: stocks)
                
            })
        }
}
