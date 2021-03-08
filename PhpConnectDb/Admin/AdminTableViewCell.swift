//
//  AdminTableViewCell.swift
//  PhpConnectDb
//
//  Created by Janarthan Subburaj on 20/02/21.
//

import UIKit

class AdminTableViewCell: UITableViewCell {

    
    @IBOutlet weak var PendingLabel: UILabel!
    @IBOutlet weak var CompletedLabel: UILabel!
    @IBOutlet weak var NameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
  
    
}
