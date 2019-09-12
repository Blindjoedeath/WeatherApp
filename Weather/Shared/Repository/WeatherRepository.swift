//
//  WeatherRepository.swift
//  Weather
//
//  Created by Oskar on 06/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import RxSwift

protocol WeatherRepositoryProtocol{
    
    var lastWeather: Observable<Weather>? {get}
    var lastForecast: Observable<Forecast>? {get}
    
    func getWeather(for city: String) -> Observable<Weather>
    func getForecast(for city: String) -> Observable<Forecast>
    
    static var instance: WeatherRepositoryProtocol {get}
}

class WeatherRepository: WeatherRepositoryProtocol{
    
    static let instance: WeatherRepositoryProtocol = WeatherRepository()
    
    var lastWeather: Observable<Weather>?
    var lastForecast: Observable<Forecast>?
    
    private init(){
        
    }
    
    func getWeather(for city: String) -> Observable<Weather>{
        let url = weatherUrl(for: city)
        lastWeather = ReactiveRequest<Weather>.create(for: url).share()
        return lastWeather!
    }
    
    func getForecast(for city: String) -> Observable<Forecast>{
        let url = forecastUrl(for: city)
        lastForecast = ReactiveRequest<Forecast>.create(for: url).share()
        return lastForecast!
    }
    
    private func weatherUrl(for city: String) -> URL{
        let urlString = String(format:
            "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@", city, weatherApiToken)
        return createUrl(for: urlString)
    }
    
    private func forecastUrl(for city: String) -> URL{
        let urlString = String(format:
            "https://samples.openweathermap.org/data/2.5/forecast?q=%@&appid=%@", city, weatherApiToken)
        return createUrl(for: urlString)
    }
    
    private func createUrl(for urlString: String) -> URL{
        let formatted = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return URL(string: formatted)!
    }
}
