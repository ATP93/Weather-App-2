//
//  WeatherServiceDelegate.swift
//  Weather-App-2
//
//  Created by Iveta Škorpilová on 14.05.17.
//  Copyright © 2017 Iveta Škorpilová. All rights reserved.
//


import UIKit

protocol WeatherServiceDelegate {
    func setWeather(_ weather: Weather)
    func weatherErrorWithMessage(_ message: String)
}
