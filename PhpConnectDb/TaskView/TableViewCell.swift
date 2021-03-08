//
//  TableViewCell.swift
//  PhpConnectDb
//
//  Created by Janarthan Subburaj on 12/02/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var Edit: UIButton!
    @IBOutlet weak var RemainDays: UILabel!
    @IBOutlet weak var StartDate: UILabel!
    @IBOutlet weak var EndDate: UILabel!
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var Task1: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func ActionTask(_ sender: Any) {
    }
    

}
