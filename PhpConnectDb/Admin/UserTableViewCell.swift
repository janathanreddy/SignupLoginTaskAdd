//
//  UserTableViewCell.swift
//  PhpConnectDb
//
//  Created by Janarthan Subburaj on 24/02/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var TaskStatus: UILabel!
    @IBOutlet weak var TaskName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
