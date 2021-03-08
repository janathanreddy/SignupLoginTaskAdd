//
//  ExpandCell.swift
//  PhpConnectDb
//
//  Created by Janarthan Subburaj on 22/02/21.
//

import UIKit


class ExpandCell: UITableViewCell {

    @IBOutlet weak var TaskStatus: UILabel!
    @IBOutlet weak var Taskname: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    class func cellHeight() -> CGFloat {
        return 44
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
