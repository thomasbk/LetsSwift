//
//  TableViewCell.swift
//  LetsSwift
//
//  Created by Thomas Baltodano on 4/21/17.
//  Copyright © 2017 Thomas Baltodano. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    @IBOutlet var gameLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var myImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
