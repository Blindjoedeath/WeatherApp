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


class WeatherRepositoryStub: WeatherRepositoryProtocol{
    
    static var instance: WeatherRepositoryProtocol = WeatherRepositoryStub()
    
    var stubbedLastWeather: Observable<Weather>!
    var lastWeather: Observable<Weather>? {
        return stubbedLastWeather
    }
    
    var stubbedLastForecast: Observable<Forecast>!
    var lastForecast: Observable<Forecast>? {
        return stubbedLastForecast
    }
    
    var stubbedGetWeatherResult: Observable<Weather>!
    func getWeather(for city: String) -> Observable<Weather> {
        return stubbedGetWeatherResult
    }
    
    var stubbedGetForecastResult: Observable<Forecast>!
    func getForecast(for city: String) -> Observable<Forecast> {
        return stubbedGetForecastResult
    }
    
}
