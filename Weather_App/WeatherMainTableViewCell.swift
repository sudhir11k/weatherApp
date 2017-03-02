//
//  WeatherMainTableViewCell.swift
//  WeatherApp
//
//  Created by Sudhir Kumar on 2/28/17.
//  Copyright © 2017 Macee. All rights reserved.
//

import UIKit
import QuartzCore

class WeatherMainTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    
    
    @IBOutlet weak var tempratureLabel: UILabel!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        iconImageView.layer.borderWidth = 1.0
        iconImageView.layer.borderColor = UIColor.black.cgColor
        iconImageView.layer.cornerRadius = 5.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
