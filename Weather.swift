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
    private var _cityUrl: String!
    private var _zipUrl: String!
    private var _sunrise: String!
    private var _sunset: String!
    private var _isNight: Bool!
    private var _wind: String!
    private var _tempHigh: String!
    
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
    
    var sunrise: String {
        if _sunrise == nil {
            _sunrise = ""
        }
        return _sunrise
    }
    
    var wind: String {
        if _wind == nil {
            _wind = ""
        }
        return _wind
    }
    
    var tempHigh: String {
        if _tempHigh == nil {
            _tempHigh = ""
        }
        return _tempHigh
    }
    
    init(city: String) {
        _city = city.stringByReplacingOccurrencesOfString(" ", withString: "_")
        
        _cityUrl = "\(URL_BASE)\(URL_CITY_BASE)\(_city)\(URL_APIKEY)"
        _zipUrl = "\(URL_BASE)\(URL_ZIP_BASE)\(_city)\(URL_APIKEY)"
    }
    
    func downloadWeatherSpecs(completed: DownloadComplete) {
        var url = NSURL()
        if let temp = NSURL(string: _cityUrl) {
            url = temp
        } else if let temp = NSURL(string: _zipUrl) {
            url = temp
        }
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let city = dict["name"] as? String {
                    self._city = city
                }
                if let kelvinTemp = dict["main"]!["temp"] as? Double, let kelvinTempHigh = dict["main"]!["temp_max"] as? Double {
                    self._temperature = "\(self.convertKelvinToFarh(kelvinTemp))°F"
                    self._tempHigh = "\(self.convertKelvinToFarh(kelvinTempHigh))°"
                }
                if let description = dict["weather"]![0]["description"] as? String {
                    self._description = description.uppercaseString
                }
                if let sunrise = dict["sys"]!["sunrise"] as? Double, let sunset = dict["sys"]!["sunset"] as? Double {
                    self._sunrise = self.nightOrDay(sunrise)
                    self._sunset = self.nightOrDay(sunset)
                }
                if let wind = dict["wind"]!["speed"] as? Double {
                    self._wind = "\(Int(wind)) mph"
                }
                
            }
            completed()
        }
        
    }
    func convertKelvinToFarh(kelvin: Double) -> Int {
        return Int(kelvin * (9/5) - 459.67)
    }
    
    func getDaytime() {
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
        
        _datetime = "\(day) \(dateString)"
        
        if calendar.component(.Hour, fromDate: date) > Int(_sunset) {
            _isNight = true
        } else {
            _isNight = false
        }
    }
    
    func nightOrDay(sun: Double) -> String {
        let unixTimestamp = sun
        let date = NSDate(timeIntervalSince1970: unixTimestamp)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "h:mm"
        let dateString = dateFormatter.stringFromDate(date)
        
        return "\(dateString)"
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
        } else {
            if _isNight != nil || !_isNight {
                _image = "night"
            } else {
                _image = "sun"
            }
        }
    }
    
}