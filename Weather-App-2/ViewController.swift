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
    
    func handleError(_ message: String) {
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        let alert = UIAlertController(title: "Weather Service Error", message: message, preferredStyle: .alert)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleWeather(_ weather: Weather) {
        self.weather = weather
        self.descriptionLabel.text = weather.description
        let numberFormatter = NumberFormatter()
        self.humidityLabel.text = "Humidity: \(numberFormatter.string(from: NSNumber(value:weather.humidity))!)%"
        self.tempLabel.text = numberFormatter.string(from: NSNumber(value:weather.tempC))!
        self.iconImageView.image = UIImage(named: weather.icon)
        self.windLabel.text = "Wind: \(numberFormatter.string(from: NSNumber(value:weather.windSpeed))!)mph"
        self.cityButton.setTitle(weather.cityName, for: UIControlState())
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





