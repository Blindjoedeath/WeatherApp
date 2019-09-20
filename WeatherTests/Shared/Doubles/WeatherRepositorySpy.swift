//
//  CityRepositoryMock.swift
//  WeatherTests
//
//  Created by Oskar on 12/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather
import RxSwift

class WeatherRepositorySpy: WeatherRepositoryProtocol{
    var invokedWeatherResultGetter = false
    var invokedWeatherResultGetterCount = 0
    var stubbedWeatherResult: Observable<WeatherResult<Weather>>!
    var weatherResult: Observable<WeatherResult<Weather>> {
        invokedWeatherResultGetter = true
        invokedWeatherResultGetterCount += 1
        return stubbedWeatherResult
    }
    var invokedForecastResultGetter = false
    var invokedForecastResultGetterCount = 0
    var stubbedForecastResult: Observable<WeatherResult<Forecast>>!
    var forecastResult: Observable<WeatherResult<Forecast>> {
        invokedForecastResultGetter = true
        invokedForecastResultGetterCount += 1
        return stubbedForecastResult
    }
    var invokedRequestTimeoutSetter = false
    var invokedRequestTimeoutSetterCount = 0
    var invokedRequestTimeout: Int?
    var invokedRequestTimeoutList = [Int]()
    var invokedRequestTimeoutGetter = false
    var invokedRequestTimeoutGetterCount = 0
    var stubbedRequestTimeout: Int! = 0
    var requestTimeout: Int {
        set {
            invokedRequestTimeoutSetter = true
            invokedRequestTimeoutSetterCount += 1
            invokedRequestTimeout = newValue
            invokedRequestTimeoutList.append(newValue)
        }
        get {
            invokedRequestTimeoutGetter = true
            invokedRequestTimeoutGetterCount += 1
            return stubbedRequestTimeout
        }
    }
    var invokedRefreshWeather = false
    var invokedRefreshWeatherCount = 0
    var invokedRefreshWeatherParameters: (city: String, Void)?
    var invokedRefreshWeatherParametersList = [(city: String, Void)]()
    func refreshWeather(for city: String) {
        invokedRefreshWeather = true
        invokedRefreshWeatherCount += 1
        invokedRefreshWeatherParameters = (city, ())
        invokedRefreshWeatherParametersList.append((city, ()))
    }
    var invokedRefreshForecast = false
    var invokedRefreshForecastCount = 0
    var invokedRefreshForecastParameters: (city: String, Void)?
    var invokedRefreshForecastParametersList = [(city: String, Void)]()
    func refreshForecast(for city: String) {
        invokedRefreshForecast = true
        invokedRefreshForecastCount += 1
        invokedRefreshForecastParameters = (city, ())
        invokedRefreshForecastParametersList.append((city, ()))
    }
}
