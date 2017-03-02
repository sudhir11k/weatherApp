
//
//  ViewController.swift
//  WeatherApp
//
//  Created by Sudhir Kumar on 2/28/17.
//  Copyright © 2017 Macee. All rights reserved.
//

import UIKit



enum weatherKeyValue: String
{
    case temp = "temp"
    case pressure = "pressure"
    case humidity = "humidity"
    case temp_min = "temp_min"
    case temp_max = "temp_max"
    case speed = "speed"
    case sunrise = "sunrise"
    case sunset = "sunset"
    
    func weatherKeyName() -> String {
        var value = ""
        switch self {
        case .temp : value = "temperature"
        case .pressure : value = "Pressure"
        case .humidity : value  = "humidity"
        case .temp_min : value  = "Min Temperature"
        case .temp_max : value  = "Max Temperature"
        case .speed : value  = "Wind Speed"
        case .sunrise : value  = "Sunrise"
        case .sunset : value  = "Sunset"
            
        }
        return value
    }
}




class WeatherViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    
    @IBOutlet weak var searchbar: UISearchBar!
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    var tableDataSourceArray = [Any]()
    var searchActive : Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        /*
         If NSuserdefaults has the value for Key then display the old searched city weather
         */
        if let cityName = UserDefaults.standard.value(forKey: "CITY_NAME") as? String{
            self.callForGetWeatherDataAsPerCity(cityName: cityName)
        }
        
        self.weatherTableView.dataSource = self
        self.weatherTableView.delegate = self
        
        self.weatherTableView.rowHeight = UITableViewAutomaticDimension
        self.weatherTableView.estimatedRowHeight = 50.0
        self.weatherTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     callForGetWeatherDataAsPerCity fuction ----> responsible to hit service data with input cityName and through completion handler results wheater correct Data for dispaly we get or not, data if any we have in form of dictionary and error if any oocured
     */
    
    func callForGetWeatherDataAsPerCity(cityName:String){
        
        WeatherAppManager.sharedStore.fetchweatherDetailsOfCity(cityName: cityName) { (resultStatus, data, error) in
            
            
            if resultStatus == true{
                
                if let weatherData = data as? Dictionary<AnyHashable,Any>{
                    
                    self.sortWetaherDataAsperKeys(weatherData: weatherData)
                    
                    UserDefaults.standard.setValue(cityName, forKey: "CITY_NAME")
                    UserDefaults.standard.synchronize()
                    
                }else{
                    
                }
                
                
            }else{
                self.alert(message: "Some thing went wrong please try again later")
            }
            
        }
        
        
    }
    
    
    /*
     sortWetaherDataAsperKeys fuction ----> it will filter the dictionary with in dictinary and based on the deep down level mentioned in keyArrayforFilter, we store the the data, DIctionary Extension has been used to get hashable key
     */
    
    
    func sortWetaherDataAsperKeys(weatherData:Dictionary<AnyHashable,Any>){
        
        var weatherTableData = [Any]()
        
        let keyArrayforFilter =  [["weather"],["main","temp"],["main","pressure"],["main","humidity"],["main","temp_min"],["main","temp_max"],["wind","speed"],["sys","sunrise"],["sys","sunset"]]
        
        for value in keyArrayforFilter{
            
            if let keyValue = weatherData.getValue(forKeyPath: value) as? Any{
                var dict : Dictionary<String,Any> = [:]
                dict[value.last!] = keyValue
                weatherTableData.append(dict)
            }
            
        }
        
        self.tableDataSourceArray.removeAll()
        self.tableDataSourceArray = weatherTableData
        
        DispatchQueue.main.async
            {
                self.weatherTableView.reloadData()
        }
        
    }
    
    // MARK: - Table View DataSource and Delegate methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("self.tableDataSourceArray.count \(self.tableDataSourceArray.count)")
        return self.tableDataSourceArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let indexDict : Dictionary<String,Any> = self.tableDataSourceArray[indexPath.row] as! Dictionary<String, Any>
        
        
        for (key, value) in indexDict{
            
            
            if key == "weather"{
                
                /*
                 weather key value is dictionay to display first cell value against some value
                 */
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTopCell", for: indexPath as IndexPath) as! WeatherMainTableViewCell
                
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                
                let weatherDict : Dictionary<String,Any>= (indexDict["weather"] as! Array).first!
                
                //http://openweathermap.org/img/w/10d.png
                
                let fileUrlString = "http://openweathermap.org/img/w/" + (weatherDict["icon"] as! String?)! + ".png"
                let imagePath = NSURL(string: fileUrlString)
                
                cell.iconImageView?.downloadedFrom(link: imagePath!, contentMode: .scaleAspectFit)
                
                cell.tempratureLabel.text = (weatherDict["description"] as! String?)?.capitalized
                
                cell.cityNameLabel.text = UserDefaults.standard.value(forKey: "CITY_NAME") as! String?
                
                return cell
            }else{
                
                /*
                 rest of key value can be of any form, String and Number has been taken care, if any other data type will encounter it will by pass with black string
                 */
                
                var trimmedValue : String = ""
                if let value1 = value as? String{
                    trimmedValue = value1.trimmingCharacters(in: CharacterSet.whitespaces)
                }else if let value1 = value as? NSNumber{
                    trimmedValue = value1.stringValue as String!
                    trimmedValue = trimmedValue.trimmingCharacters(in: CharacterSet.whitespaces)
                }else{
                    trimmedValue = ""
                }
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! SimpleTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                
                
                cell.leftLabel.text = self.getKeyValueName(key: key)
                
                cell.rightLabel.text = self.getValueWithUnitsName(key: key, value:trimmedValue.capitalized)
                return cell
            }
            
            
        }
        
        return UITableViewCell()
        
    }
    
    
    
    /*
     sortWetaherDataAsperKeys fuction ----> get the appropriate value against the key available in response
     */
    
    func getKeyValueName(key: String)->String{
        if let keyType = weatherKeyValue(rawValue: key)
        {
            switch keyType
            {
            case .temp:
                return weatherKeyValue.temp.weatherKeyName().capitalized
            case .pressure:
                return  weatherKeyValue.pressure.weatherKeyName().capitalized
            case .humidity:
                return  weatherKeyValue.humidity.weatherKeyName().capitalized
            case .temp_min:
                return  weatherKeyValue.temp_min.weatherKeyName().capitalized
            case .temp_max:
                return  weatherKeyValue.temp_max.weatherKeyName().capitalized
            case .speed:
                return  weatherKeyValue.speed.weatherKeyName().capitalized
            case .sunrise:
                return  weatherKeyValue.sunrise.weatherKeyName().capitalized
            case .sunset:
                return  weatherKeyValue.sunset.weatherKeyName().capitalized
                
            }
        }else{
            return  ""
        }
        
    }
    
    func getValueWithUnitsName(key: String, value:String)->String{
        if let keyType = weatherKeyValue(rawValue: key)
        {
            switch keyType
            {
            case .temp:
                return value + " K"
            case .pressure:
                return  value + " hpa"
            case .humidity:
                return  value + " %"
            case .temp_min:
                return  value + " hpa"
            case .temp_max:
                return  value + " K"
            case .speed:
                return  value
            case .sunrise:
                return  value
            case .sunset:
                return  value
                
            }
        }else{
            return  ""
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Table View DataSource and Delegate methods
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.callForGetWeatherDataAsPerCity(cityName: searchBar.text!)
    }
    
    
}

