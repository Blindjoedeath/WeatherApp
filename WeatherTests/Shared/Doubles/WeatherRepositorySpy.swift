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
    
    var invokedLastWeatherGetter = false
    var invokedLastWeatherGetterCount = 0
    var stubbedLastWeather: Observable<Weather>!
    var lastWeather: Observable<Weather>? {
        invokedLastWeatherGetter = true
        invokedLastWeatherGetterCount += 1
        return stubbedLastWeather
    }
    var invokedLastForecastGetter = false
    var invokedLastForecastGetterCount = 0
    var stubbedLastForecast: Observable<Forecast>!
    var lastForecast: Observable<Forecast>? {
        invokedLastForecastGetter = true
        invokedLastForecastGetterCount += 1
        return stubbedLastForecast
    }
    var invokedGetWeather = false
    var invokedGetWeatherCount = 0
    var invokedGetWeatherParameters: (city: String, Void)?
    var invokedGetWeatherParametersList = [(city: String, Void)]()
    var stubbedGetWeatherResult: Observable<Weather>!
    func getWeather(for city: String) -> Observable<Weather> {
        invokedGetWeather = true
        invokedGetWeatherCount += 1
        invokedGetWeatherParameters = (city, ())
        invokedGetWeatherParametersList.append((city, ()))
        return stubbedGetWeatherResult
    }
    var invokedGetForecast = false
    var invokedGetForecastCount = 0
    var invokedGetForecastParameters: (city: String, Void)?
    var invokedGetForecastParametersList = [(city: String, Void)]()
    var stubbedGetForecastResult: Observable<Forecast>!
    func getForecast(for city: String) -> Observable<Forecast> {
        invokedGetForecast = true
        invokedGetForecastCount += 1
        invokedGetForecastParameters = (city, ())
        invokedGetForecastParametersList.append((city, ()))
        return stubbedGetForecastResult
    }
}
