//
//  WeatherInteractorOutputSpy.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 18/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather

class WeatherInteractorOutputSpy: WeatherInteractorOutput{
    var invokedNoNetwork = false
    var invokedNoNetworkCount = 0
    func noNetwork() {
        invokedNoNetwork = true
        invokedNoNetworkCount += 1
    }
    var invokedNoLocation = false
    var invokedNoLocationCount = 0
    func noLocation() {
        invokedNoLocation = true
        invokedNoLocationCount += 1
    }
    var invokedWeatherRequestTimeOut = false
    var invokedWeatherRequestTimeOutCount = 0
    var weatherRequestTimeOutHandler: (() -> ())?
    func weatherRequestTimeOut() {
        invokedWeatherRequestTimeOut = true
        invokedWeatherRequestTimeOutCount += 1
        weatherRequestTimeOutHandler?()
    }
    var invokedFoundWeather = false
    var invokedFoundWeatherCount = 0
    var invokedFoundWeatherParameters: (weather: Weather, Void)?
    var invokedFoundWeatherParametersList = [(weather: Weather, Void)]()
    func found(weather: Weather) {
        invokedFoundWeather = true
        invokedFoundWeatherCount += 1
        invokedFoundWeatherParameters = (weather, ())
        invokedFoundWeatherParametersList.append((weather, ()))
    }
    var invokedFoundWeekForecast = false
    var invokedFoundWeekForecastCount = 0
    var invokedFoundWeekForecastParameters: (weekForecast: [Weather], Void)?
    var invokedFoundWeekForecastParametersList = [(weekForecast: [Weather], Void)]()
    func found(weekForecast: [Weather]) {
        invokedFoundWeekForecast = true
        invokedFoundWeekForecastCount += 1
        invokedFoundWeekForecastParameters = (weekForecast, ())
        invokedFoundWeekForecastParametersList.append((weekForecast, ()))
    }
    var invokedSetStyle = false
    var invokedSetStyleCount = 0
    var invokedSetStyleParameters: (appStyle: AppStyle, Void)?
    var invokedSetStyleParametersList = [(appStyle: AppStyle, Void)]()
    func setStyle(appStyle: AppStyle) {
        invokedSetStyle = true
        invokedSetStyleCount += 1
        invokedSetStyleParameters = (appStyle, ())
        invokedSetStyleParametersList.append((appStyle, ()))
    }
}
