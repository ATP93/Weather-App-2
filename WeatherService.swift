//
//  WeatherService.swift
//  Weather-App-Example
//
//  Created by Iveta Škorpilová on 14.05.17.
//  Copyright © 2017 Iveta Škorpilová. All rights reserved.
//


import UIKit
import CoreLocation

class WeatherService {
    var delegate: WeatherServiceDelegate?
    var client: Sweather?
    
    init(apiKey: String) {
        self.client = Sweather(apiKey: apiKey)
    }
    
    func getWeatherForLocation(_ location: CLLocation) {
        let coordinations = location.coordinate
        
        client?.currentWeather(coordinations) { result in
            switch result {
            case .Error(_, let error):
                DispatchQueue.main.async(execute: { () -> Void in
                    self.delegate?.weatherErrorWithMessage((error?.localizedDescription)!)
                })
            case .success(_, let dictionary):
                 print("Received data: \(String(describing: dictionary))")
                 if self.delegate != nil {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.delegate?.setWeather(self.createWeather(dictionary: dictionary))
                    })
                 }
            }
        }
    }
    
    func createWeather(dictionary: NSDictionary?) -> Weather {
        var name, description, icon: String?
        var temperature, clouds, tempMin, tempMax, humidity, pressure, windSpeed: Double?
        
        if let city = dictionary?["name"] as? String, let dict = dictionary?["main"] as? NSDictionary, let cloudsDict = dictionary?["clouds"] as? NSDictionary
        {
            name = city
            temperature = dict["temp"] as? Double
            clouds = cloudsDict["all"] as? Double
            tempMin = dict["temp_min"] as? Double
            tempMax = dict["temp_max"] as? Double
            humidity = dict["humidity"] as? Double
            pressure = dict["pressure"] as? Double
            windSpeed = dict["temp"] as? Double
            if let weatherList = dictionary?["weather"] as? NSArray,
                let w1 = weatherList[0] as? NSDictionary {
                description = w1["description"] as? String
                icon = w1["icon"] as? String
            }
        }
        
        let weather = Weather(
            cityName: name!,
            temp: temperature!,
            description: description!,
            icon: icon!,
            clouds: clouds!,
            tempMin: tempMin!,
            tempMax: tempMax!,
            humidity: humidity!,
            pressure: pressure!,
            windSpeed: windSpeed!
        )
        print(weather)
        return weather
    }    
}
