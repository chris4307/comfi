//
//  TransactionEntryCell.swift
//  ChrisAndJustinsPages
//
//  Created by Justin Kim on 10/14/18.
//  Copyright © 2018 CJ LLC. All rights reserved.
//

import UIKit

class TransactionEntryCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
