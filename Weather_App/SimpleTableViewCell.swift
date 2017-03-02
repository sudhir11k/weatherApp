//
//  SimpleTableViewCell.swift
//  WeatherApp
//
//  Created by Sudhir Kumar on 2/28/17.
//  Copyright © 2017 Macee. All rights reserved.
//

import UIKit

class SimpleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftLabel: UILabel!
    

    @IBOutlet weak var rightLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
