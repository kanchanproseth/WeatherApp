//
//  ViewController.swift
//  WeatherApp
//
//  Created by Kan Chanproseth on 12/20/16.
//  Copyright © 2016 Kan Chanproseth. All rights reserved.
//

import UIKit
import SideMenuController
var arrSagement = [String]()
var typeOfDegree: String?
var currentCityname = [String]()
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SideMenuControllerDelegate{
    var data: Data?
    var _weatherType: String!
    var _currentTemp: Double!
    var _currentWindSpeed: Double!
    var forecast: Forecast!
    var forecasts = [Forecast]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshdataIndicator: UIActivityIndicatorView!
    //Current Data
    @IBOutlet weak var CurrentWeather: UILabel!
    @IBOutlet weak var CurrentWeatherDescription: UILabel!
    @IBOutlet weak var CurrentCity: UILabel!
    
   
    //CurrentDetail when refresh
    @IBOutlet weak var UpdatedTimeDetails: UILabel!

    
    
//    override func viewDidDisappear(_ animated: Bool) {
//    }
    func receivePush(_ noti : NSNotification){
        if let userInfo = noti.userInfo as? [String: Any] // or use if you know the type  [AnyHashable : Any]
        {
            print(userInfo)
            
            if let message = userInfo["message"] as? String {
                typeOfDegree = message
            }
        }
        print(noti.userInfo!.values)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(receivePush(_:)), name: NSNotification.Name(rawValue: "receivePush"), object: nil)
        print("*************************************\(typeOfDegree)")
        tableView.delegate = self
        tableView.dataSource = self
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if arrCity.count > 0 {
            print("111111111\(arrCity[0])")
            loadData(arrCity[0])
            loadNextDayData(arrCity[0])
        }else{
            if currentCityname.count == 1 {
                loadData(currentCityname[0])
                loadNextDayData(currentCityname[0])
            }else{
            loadData(CurrentCity.text!)
            loadNextDayData(CurrentCity.text!)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
       tableView.reloadData()
        super.viewWillAppear(animated)
        print("\(#function) -- \(self)")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "receivePush"), object: nil);
        print("\(#function) -- \(self)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
    }
    
    public func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {
    }
    @IBAction func Menu(_ sender: Any) {
        sideMenuController?.toggle()
    }
    @IBAction func ReloadData(_ sender: Any) {
        loadData(CurrentCity.text!)
        loadNextDayData(CurrentCity.text!)
    }
    func loadData(_ cityname:String){
        self.refreshdataIndicator.isHidden = false
        self.refreshdataIndicator.startAnimating()
        CurrentCity.text = cityname
        currentCityname.removeAll(keepingCapacity: false)
        currentCityname.append(CurrentCity.text!)
        let urlStr = "http://api.openweathermap.org/data/2.5/weather?q=\(cityname.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)&appid=965a2c6acdab9054673c5ecbd0cbf2b6"
        print(urlStr)
        let url = URL(string: urlStr)
        let request = URLRequest(url: url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        let task = session.dataTask(with: request, completionHandler: {
            data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        
                        if let weather = json["weather"] as? [Dictionary<String, AnyObject>] {
                            if let main = weather[0]["main"] as? String {
                                self._weatherType = main.capitalized
                                print(self._weatherType)
                            }
                        }
                        if let main = json["main"] as? Dictionary<String, AnyObject> {
                            print(main)
                            if let currentTemperature = main["temp"] as? Double {
                                
                                let kelvinToFarenheitPreDivision = (currentTemperature * (9/5) - 459.67)
                                
                                let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                                let kelvinToCelcius = currentTemperature - 273.15
                                DispatchQueue.main.async {
                                    if typeOfDegree == "C"{
                                        self._currentTemp = kelvinToCelcius
                                    }else{
                                        self._currentTemp = kelvinToFarenheit
                                    }
                                    self.CurrentWeather.text = "\(round(self._currentTemp!))°"
                                }
                                
                                
                            }
                        }
                        if let main = json["wind"] as? Dictionary<String, AnyObject> {
                            print(main)
                            self._currentWindSpeed = main["speed"] as? Double
                        }
                    }
                    DispatchQueue.main.async {
                        self.CurrentWeatherDescription.text = ("Weather: \(self._weatherType!), Wind:\(self._currentWindSpeed!)Km/h")
                        
                        self.refreshdataIndicator.isHidden = true
                        self.refreshdataIndicator.stopAnimating()
                        let date = NSDate()
                        let calendar = NSCalendar.current
                        let currentyear = calendar.component(.year, from: date as Date)
                        let currentmonth = calendar.component(.month, from: date as Date)
                        let currentday = calendar.component(.day, from: date as Date)
                        let hour = calendar.component(.hour, from: date as Date)
                        let minutes = calendar.component(.minute, from: date as Date)
                        self.UpdatedTimeDetails.text = "Updated: \(currentyear)-\(currentmonth)-\(currentday) at \(hour):\(minutes) "
                    }
                    
                    arrCity.removeAll(keepingCapacity: false)
                } catch {
                    print("error in JSONSerialization")
                }
            }
        })
        
        task.resume()
        
        
    }
    func loadNextDayData(_ cityname:String){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let urlStr = "http://api.openweathermap.org/data/2.5/forecast?q=\(cityname.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)&appid=965a2c6acdab9054673c5ecbd0cbf2b6"
        let url = URL(string: urlStr)
        let request = URLRequest(url: url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request, completionHandler: {
            data, response, error in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        if let list = json["list"] as? [Dictionary<String, AnyObject>] {
                            
                            for obj in list {
                                let forecast = Forecast(weatherDict: obj)
                                self.forecasts.append(forecast)
                            }
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        }
                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
        })
        
        task.resume()

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "daycell", for: indexPath) as? WeatherCell
        if typeOfDegree == "C"{
            let forecast = forecasts[indexPath.row]
            cell?.configureCellForCelCius(forecast: forecast)
            cell?.selectionStyle = .none
        }else{
            let forecast = forecasts[indexPath.row]
            cell?.configureCell(forecast: forecast)
            cell?.selectionStyle = .none
        }
        return cell!
    }
}
