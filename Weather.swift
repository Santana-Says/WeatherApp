//
//  Weather.swift
//  WeatherApp
//
//  Created by Jeffrey Santana on 9/29/17.
//  Copyright © 2017 Jeffrey Santana. All rights reserved.
//

import Foundation
import Alamofire

class Weather {
    private var _city: String!
    private var _image: String!
    private var _datetime: String!
    private var _temperature: String!
    private var _description: String!
    private var _weatherUrl: String!
    
    var city: String {
        if _city == nil {
            _city = "Miami"
        }
        return _city
    }
    
    var image: String {
        if _image == nil {
            _image = ""
        }
        return _image
    }
    
    var datetime: String {
        if _datetime == nil {
            _datetime = ""
        }
        return _datetime
    }
    
    var degrees: String {
        if _temperature == nil {
            _temperature = ""
        }
        return _temperature
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    init(city: String) {
        _city = city
        _datetime = getDayOfWeek()
        
        _weatherUrl = "\(URL_BASE)\(URL_CITY_BASE)\(_city)\(URL_COUNTRYCODE)\(URL_APIKEY)"
    }
    
    func downloadWeatherSpecs(completed: DownloadComplete) {
        let url = NSURL(string: _weatherUrl)!
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let city = dict["name"] as? String {
                    self._city = city
                }
                if let kelvinTemp = dict["main"]!["temp"] as? Double {
                    let farhTemp = Int(kelvinTemp * (9/5) - 459.67)
                    self._temperature = "\(farhTemp)"
                }
                if let description = dict["weather"]![0]["description"] as? String {
                    self._description = description.uppercaseString
                }
                
            }
            completed()
        }
    }
    
    func getDayOfWeek() -> String {
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.AMSymbol = "AM"
        dateFormatter.PMSymbol = "PM"
        let calendar = NSCalendar.currentCalendar()
        let dayUnit = calendar.component(.Weekday, fromDate: date)
        let dateString = dateFormatter.stringFromDate(date)
        let day: String!
        
        switch dayUnit {
        case 1:
            day = "Sunday"
        case 2:
            day = "Monday"
        case 3:
            day = "Tuesday"
        case 4:
            day = "Wednesday"
        case 5:
            day = "Thursday"
        case 6:
            day = "Friday"
        default:
            day = "Saturday"
        }
        
        return "\(day) \(dateString)"
    }
    
    func getImage(desc: String) {
        if desc.containsString("CLOUD") {
            _image = "cloudy"
        } else if desc.containsString("RAIN") {
            _image = "rain"
        } else if desc.containsString("SNOW") {
            _image = "snow"
        } else if desc.containsString("WIND") {
            _image = "windy"
        } else if desc.containsString("NIGHT") {
            _image = "night"
        } else {
            _image = "sun"
        }
    }
    
}