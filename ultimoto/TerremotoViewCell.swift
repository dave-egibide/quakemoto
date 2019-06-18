//
//  TerremotoViewCell.swift
//  ultimoto
//
//  Created by  on 14/6/19.
//  Copyright © 2019 Dave. All rights reserved.
//

import UIKit

class TerremotoViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!
    
    var item: RSSItem! {
        didSet {
            titleLabel.text = item.text
            descriptionLabel.text = item.magnitude
            dateLabel.text = item.time
        }
    }

    /*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 */

}
