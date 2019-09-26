//
//  WeatherRepositoryStub.swift
//  Weather
//
//  Created by Oskar on 26/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class WeatherRepositoryStub: WeatherRepository{
    
    static var stubInstance = WeatherRepositoryStub()
    
    private func createWeather() -> Weather{
        let weather = Weather()
        weather.date = Date()
        weather.description = "description"
        weather.humidity = 10
        weather.iconCode = "01d"
        weather.temperature = 10
        return weather
    }
    
    private func getHoursOf(_ date: Date) -> [Date]{
        let hours = [10, 12, 14, 16, 18]
        var result: [Date] = []
        for hour in hours{
            let houredDate = Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: date)!
            result.append(houredDate)
        }
        return result
    }
    
    private func getLastWeek() -> [Date]{
        var date = Date()
        var result = [date]
        for _ in 1...6{
            date = date.dayBefore
            result.append(date)
        }
        return result
    }
    
    lazy var weather = {
        return self.createWeather()
    }()
    
    lazy var forecast: Forecast = {
        var weathers  : [Weather] = []
        var dates = getLastWeek().flatMap{ getHoursOf($0) }
        for date in dates{
            let weather = createWeather()
            weather.date = date
            weathers.append(weather)
        }
        return Forecast(from: weathers)
    }()
    
    override func refreshWeather(for city: String) {
        let result = WeatherResult.success(weather)
        weatherSubject.onNext(result)
    }
    
    override func refreshForecast(for city: String) {
        let result = WeatherResult.success(forecast)
        forecastSubject.onNext(result)
    }
}
