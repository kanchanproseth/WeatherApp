//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Kan Chanproseth on 12/22/16.
//  Copyright © 2016 Kan Chanproseth. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!

    
    
    func configureCell(forecast: Forecast) {
        lowTemp.text = "\(forecast.lowTemp)°"
        highTemp.text = "\(forecast.highTemp)°"
        weatherType.text = forecast.weatherType
        
        weatherIcon.image = UIImage(named: forecast.weatherType)
        dayLabel.text = forecast.date
    }
    func configureCellForCelCius(forecast: Forecast) {
        lowTemp.text = "\(round((forecast.lowTemp - 32) / 1.8))°"
        highTemp.text = "\(round((forecast.highTemp - 32) / 1.8))°"
        weatherType.text = forecast.weatherType
        
        weatherIcon.image = UIImage(named: forecast.weatherType)
        dayLabel.text = forecast.date
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
