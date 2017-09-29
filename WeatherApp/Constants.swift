//
//  Constants.swift
//  WeatherApp
//
//  Created by Jeffrey Santana on 9/29/17.
//  Copyright © 2017 Jeffrey Santana. All rights reserved.
//

import Foundation

let URL_BASE = "https://api.openweathermap.org/data/2.5/weather?"
let URL_CITY_BASE = "q="
let URL_COUNTRYCODE = ",us"
let URL_ZIP_BASE = "zip="
let URL_APIKEY = "&APPID=6aa3c8484d5d0fff71a1310690c0970f"

typealias DownloadComplete = () -> ()