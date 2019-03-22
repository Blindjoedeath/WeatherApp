//
//  WeatherViewProtocol.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol WeatherViewProtocol: class{
    
    func showAlert(title: String, message: String)
    func setTitle(title: String)
    
    func setAppStyle(style: AppStyleModel)
    func setCurrentWeather(weather: WeatherModel)
    func setWeekForecastData(forecast: [WeatherItem])
    func shareImage(with: String)
    func close()
    
    var isUpdateIndicatorEnabled: Bool {get set}
}
