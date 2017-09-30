////
//  ViewController.swift
//  WeatherApp
//
//  Created by Jeffrey Santana on 9/29/17.
//  Copyright © 2017 Jeffrey Santana. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var datetimeLbl: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var windLbl: UILabel!
    @IBOutlet weak var tempHighLbl: UILabel!
    @IBOutlet weak var bottomStack: UIStackView!
    
    var weather: Weather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        
    }
    
    func updateUI() {
        weather.getDaytime()
        datetimeLbl.text = weather.datetime
        tempLbl.text = weather.degrees
        descriptionLbl.text = weather.description
        weather.getImage(descriptionLbl.text!)
        weatherImg.image = UIImage(named: "\(weather.image)")
        cityLbl.text = weather.city
        sunriseLbl.text = weather.sunrise
        windLbl.text = weather.wind
        tempHighLbl.text = weather.tempHigh
        bottomStack.hidden = false
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
        weather = Weather(city: searchBar.text!)
        weather.downloadWeatherSpecs { () -> () in
            self.updateUI()
        }
    }


}

