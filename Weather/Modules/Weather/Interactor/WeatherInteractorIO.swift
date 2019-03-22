//
//  WeatherInteractor.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol WeatherInteractorInput: class{
    func configure()
    func close()
    func refreshData(for: String)
    func getAllWeather()
    func getStyle() -> AppStyleModel
}

protocol WeatherInteractorOutput: class{
    func noNetwork()
    func noLocation()
    func weatherRequestTimeOut()
    func found(weather: WeatherModel)
    func found(weekForecast: [WeatherModel])
    func found(dayForecast: [WeatherModel])
}
