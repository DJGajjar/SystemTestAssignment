//
//  TypicodeCell.swift
//  AWSAssignment
//
//  Created by Darshan Jolapara on 17/08/25.
//

import UIKit

class TypicodeCell: UITableViewCell {

    //MARK:- Label Outlet
    @IBOutlet var lblID: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
