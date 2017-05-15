//
//  ViewController.swift
//  Weather-App-2
//
//  Created by Iveta Škorpilová on 14.05.17.
//  Copyright © 2017 Iveta Škorpilová. All rights reserved.
//

import UIKit
import CoreLocation
import Social

class ViewController: UIViewController,
    CLLocationManagerDelegate,
    WeatherServiceDelegate {
    
    let locationManager = CLLocationManager()
    var weatherService = WeatherService(apiKey: "b733d502184df5ed5133054473f60b5d")
    var weather: Weather?
    
    
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    @IBAction func cityButtonTapped(_ sender: AnyObject) {
        print("City button")
        self.getGPSLocation()
    }
    
    

    func getGPSLocation() {
        locationManager.startUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        self.weatherService.getWeatherForLocation(locations[0])
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location error \(error) \(String(describing: error._userInfo))")
    }
    
    func weatherErrorWithMessage(_ message: String) {
        let alert = UIAlertController(title: "Weather Service Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func setWeather(_ weather: Weather) {
        let numberFormatter = NumberFormatter()
        self.descriptionLabel.text = weather.description
        
        self.tempLabel.text = numberFormatter.string(from: NSNumber(value:weather.tempC))!
        self.humidityLabel.text = "Humidity: \(numberFormatter.string(from: NSNumber(value:weather.humidity))!)%"
        self.windLabel.text = "Wind: \(numberFormatter.string(from: NSNumber(value:weather.windSpeed))!)mph"
        self.iconImageView.image = UIImage(named: weather.icon)
        self.cityButton.setTitle(weather.cityName, for: UIControlState())
        
        self.weather = weather
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.weatherService.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        self.getGPSLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}





