//
//  ChooseTableViewCell.swift
//  PhpConnectDb
//
//  Created by Janarthan Subburaj on 23/02/21.
//

import UIKit

class ChooseTableViewCell: UITableViewCell {

    @IBOutlet weak var NameLabel: UILabel!
    
    @IBOutlet weak var ChooseBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func ChooseAct(_ sender: Any) {
    }
}
