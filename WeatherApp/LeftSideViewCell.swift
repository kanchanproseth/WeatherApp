//
//  LeftSideViewCell.swift
//  WeatherApp
//
//  Created by Cyberk on 12/20/16.
//  Copyright © 2016 Kan Chanproseth. All rights reserved.
//

import UIKit

class LeftSideViewCell: UITableViewCell {

    @IBOutlet weak var CityName: UILabel!
    
    
    func configureCell(city:City){
        CityName.text = city.cityname
        
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
