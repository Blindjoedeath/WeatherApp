//
//  ModelService.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

internal class ModelService{
    static func WeatherToModel(from weather: Weather) -> WeatherModel{
        return WeatherModel(temperature: weather.temperature.temperatureStyled,
                                 humidity: String(weather.humidity),
                                 description: weather.description.firstLetterCapitalized,
                                 date: weather.date,
                                 iconCode: weather.iconCode,
                                 perceivedTemperature: String(weather.perceivedTemperature))
    }
}
