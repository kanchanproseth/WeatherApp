//
//  CustomSideMenuController.swift
//  WeatherApp
//
//  Created by Kan Chanproseth on 12/20/16.
//  Copyright © 2016 Kan Chanproseth. All rights reserved.
//

import UIKit
import SideMenuController

class CustomSideMenuController: SideMenuController{
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performSegue(withIdentifier: "embedInitialCenterController", sender: nil)
        performSegue(withIdentifier: "embedSideController", sender: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
