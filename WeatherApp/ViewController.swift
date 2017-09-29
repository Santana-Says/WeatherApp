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
    
    var weather: Weather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        weather = Weather(city: "Colorado")
        print(weather.city)
        print(weather.datetime)
        weather.downloadWeatherSpecs { () -> () in
            self.updateUI()
        }
        
    }
    
    func updateUI() {
        datetimeLbl.text = weather.datetime
        tempLbl.text = weather.degrees
        descriptionLbl.text = weather.description
        weather.getImage(descriptionLbl.text!)
        weatherImg.image = UIImage(named: "\(weather.image)")
        cityLbl.text = weather.city
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }


}

