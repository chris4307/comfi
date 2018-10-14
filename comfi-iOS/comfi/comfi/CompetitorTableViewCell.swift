//
//  CompetitorTableViewCell.swift
//  comfi
//
//  Created by Brian Li on 10/14/18.
//

import UIKit
import WebKit

class CompetitorTableViewCell: UITableViewCell {

    @IBOutlet var webView: WKWebView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
