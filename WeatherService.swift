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
    // Set your appid
    var appid : String
    var delegate: WeatherServiceDelegate?
    var client: Sweather?
    
    /** Initial a WeatherService instance with your OpenWeatherMap app id. */
    init(appid: String) {
        self.appid = appid
        self.client = Sweather(apiKey: appid)
    }
    
    /** Formats an API call to the OpenWeatherMap service. Pass in a CLLocation to retrieve weather data for that location.  */
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
        
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        // Put together a URL With lat and lon
        let path = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(appid)"
        
        //getWeatherWithPath(path)
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
    

    
    /** This Method retrieves weather data from an API path. */
    func getWeatherWithPath(_ path: String) {
        // Create a URL, Session, and Data task.
        let url = URL(string: path)
        let session = URLSession.shared
        let task = session.dataTask(with: url!, completionHandler: {
            data, response, error in
            
            // Handle an HTTP status response.
            if let httpResponse = response as? HTTPURLResponse {
                print("*******")
                print(httpResponse.statusCode)
                print("*******")
            }
            
            var json = JSON.null
            // Check for nil data
            do {
                json = try JSON(data: data!)
            } catch {
                print(error)
            }
            
            if json == JSON.null {
                return
            }
            
            // Get the cod code: 401 Unauthorized, 404 file not found, 200 Ok!
            // ! OpenWeatherMap returns 404 as a string but 401 and 200 are Int!?
            var status = 0
            
            if let cod = json["cod"].int {
                status = cod
            } else if let cod = json["cod"].string {
                status = Int(cod)!
            }
            
            // Check status
            // print("Weather status code:\(status)")
            if status == 200 {
                // everything is ok get the weather data from the json data.
                let _ = json["coord"]["lon"].double
                let _ = json["coord"]["lat"].double
                let temp = json["main"]["temp"].double
                let tempMin = json["main"]["temp_min"].double
                let tempMax = json["main"]["temp_max"].double
                let humidity = json["main"]["humidity"].double
                let pressure = json["main"]["pressure"].double
                let name = json["name"].string
                let desc = json["weather"][0]["description"].string
                let icon = json["weather"][0]["icon"].string
                let clouds = json["clouds"]["all"].double
                let windSpeed = json["wind"]["speed"].double
                
                // Create a Weather struct to pass to the delegate.
                let weather = Weather(
                    cityName: name!,
                    temp: temp!,
                    description: desc!,
                    icon: icon!,
                    clouds: clouds!,
                    tempMin: tempMin!,
                    tempMax: tempMax!,
                    humidity: humidity!,
                    pressure: pressure!,
                    windSpeed: windSpeed!
                )
                print("DVOJKA \(weather)")
                
                // Check the delegate has been set.
                if self.delegate != nil {
                    // The Session runs on a background thread move back to the main queue
                    // and pass the weather to our delegate.
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.delegate?.setWeather(weather)
                    })
                }

            } else if status == 404 {
                // City not found
                if self.delegate != nil {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.delegate?.weatherErrorWithMessage("City not found")
                    })
                }
                
            } else {
                // Some other here?
                if self.delegate != nil {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.delegate?.weatherErrorWithMessage("Something went wrong?")
                    })
                }
                
            }
            
        })
        
        // *** This starts the data session *** 
        task.resume()
    }
    
}
