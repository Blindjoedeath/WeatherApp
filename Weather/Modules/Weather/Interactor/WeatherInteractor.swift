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

class WeatherInteractor{
    
    weak var output: WeatherInteractorOutput!
    var weatherRequest: WeatherRequest<Weather>?
    var forecastRequest: WeatherRequest<Forecast>?
    
    func checkWeather() -> Bool{
        if let weather = WeatherRequestStorage.weather{
            if let result = checkRequestResult(for: weather){
                output.found(weather: ModelService.WeatherToModel(from: result))
                return true
            }
        }
        return false
    }
    
    func weekForecast(from forecast: Forecast) -> [Weather]{
        var result : [Weather] = []
        for i in 0..<forecast.daysCount{
            result.append(forecast[i, 2])
        }
        return result
    }
    
    func checkForecast(){
        if let forecast = WeatherRequestStorage.forecast{
            if let result = checkRequestResult(for: forecast){
                let weekModels = weekForecast(from: result).map{ModelService.WeatherToModel(from: $0)}
                let dayModels = result[0].map{ModelService.WeatherToModel(from: $0)}
                output.found(weekForecast: weekModels)
                output.found(dayForecast: dayModels)
            }
        }
    }
    
    func checkRequestResult<T>(for result: RequestResult<T>) -> T?{
        switch result {
        case .result(let data):
            return data
        case .noNetwork:
            self.output.noNetwork()
        case .noLocation:
            self.output.noLocation()
        case .timeOut:
            self.output.weatherRequestTimeOut()
        }
        return nil
    }
    
    deinit {
        print("Weather Interactor deinited")
    }
}

extension WeatherInteractor: WeatherInteractorInput{
    
    func configure() {
        WeatherRequestStorage.registerDelegate(my: self)
    }
    
    func close(){
        WeatherRequestStorage.unregisterDelegate(my: self)
        weatherRequest?.cancel()
        forecastRequest?.cancel()
    }
    
    func refreshData(for city: String) {
        WeatherRequestStorage.clear()
        weatherRequest?.cancel()
        forecastRequest?.cancel()
        
        weatherRequest = WeatherRequest<Weather>(url: ApiUrlService.weatherUrl(for: city))
        forecastRequest = WeatherRequest<Forecast>(url: ApiUrlService.forecastUrl(for: city))
        
        weatherRequest!.perform{result in
            WeatherRequestStorage.weather = result
        }
        
        forecastRequest!.perform{result in
            WeatherRequestStorage.forecast = result
        }
    }
    
    func getAllWeather() {
        if let _ = WeatherRequestStorage.weather{
            let success = checkWeather()
            if success{
                checkForecast()
            }
        } else {
            checkForecast()
        }
    }
    
    func getStyle() -> AppStyleModel {
        let style = AppStyleService.currentStyle
        let color = AppColor(r: style.color.r,
                             g: style.color.g,
                             b: style.color.b)
        
        return AppStyleModel(name: style.name,
                             description: style.description,
                             color: color)
    }
}


extension WeatherInteractor: WeatherRequestStorageDelegate{
    func weatherDidSet() {
        checkWeather()
    }
    
    func forecastDidSet() {
        checkForecast()
    }
}
