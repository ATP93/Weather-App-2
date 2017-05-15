//
//  Weather.swift
//  Weather-App-Example
//
//  Created by Iveta Škorpilová on 14.05.17.
//  Copyright © 2017 Iveta Škorpilová. All rights reserved.
//


import Foundation

struct Weather {
    let cityName: String
    let temp: Double
    let description: String
    let icon: String
    let clouds: Double
    
    let tempMin: Double
    let tempMax: Double
    
    let humidity: Double
    let pressure: Double
    
    let windSpeed: Double
    
    var tempC: Double {
        get {
            return ((temp - 32)*(5/9))
        }
    }
    
    var tempMinC: Double {
        get {
            return ((temp - 32)*(5/9))
        }
    }
    
    var tempMaxC: Double {
        get {
            return ((temp - 32)*(5/9))
        }
    }

    
    init(cityName: String,
        temp: Double,
        description: String,
        icon: String,
        clouds: Double,
        tempMin: Double,
        tempMax: Double,
        humidity: Double,
        pressure: Double,
        windSpeed: Double) {
            
            self.cityName = cityName
            self.temp = temp
            self.description = description
            self.icon = icon
            self.clouds = clouds
            self.tempMin = tempMin
            self.tempMax = tempMax
            self.humidity = humidity
            self.pressure = pressure
            self.windSpeed = windSpeed
    }
    
}
