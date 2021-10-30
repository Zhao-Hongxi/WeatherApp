//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by ivan on 2021/10/29.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var imgWeather: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
