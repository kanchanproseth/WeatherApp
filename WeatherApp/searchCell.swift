//
//  searchCellTableViewCell.swift
//  WeatherApp
//
//  Created by Kan Chanproseth on 12/30/16.
//  Copyright © 2016 Kan Chanproseth. All rights reserved.
//

import UIKit

class searchCell: UITableViewCell {
    
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
