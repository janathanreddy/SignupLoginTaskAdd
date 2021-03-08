//
//  StockModel.swift
//  PhpConnectDb
//
//  Created by Janarthan Subburaj on 16/02/21.
//

import Foundation

import UIKit

class StockModel: NSObject {
    
    //properties of a stock
    
    var TaskName: String?
    var TaskStatus: String?
   
    
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name and @price parameters
    
    init(TaskName: String, TaskStatus: String) {
        
        self.TaskName = TaskName
        self.TaskStatus = TaskStatus
       
        
    }
    
    
    //prints a stock's name and price
    
    override var description: String {
        return "TaskName: \(String(describing: TaskName)), TaskStatus: \(String(describing: TaskStatus))"
        
    }

}
