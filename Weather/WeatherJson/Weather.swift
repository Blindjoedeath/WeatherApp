//
//  Weather.swift
//  Weather
//
//  Created by Blind Joe Death on 08/11/2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import Foundation
import UIKit

class Weather: Codable {
    var temperature: Int
    var humidity: Int
    var description: String
    var icon: UIImage
    var date: Date?
    private var windSpeed: Float
    private var weatherId: Int
    private var iconCode: String
    
    var perceivedTemperature: String {
        get{
            let a = 0.478 + 0.237 * sqrt(windSpeed) - 0.0124 * windSpeed
            let b = Float(temperature - 33)
            let c = Int(33 + a * b)
            return c.temperatureStyled
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case main
        case wind
        case weather
        case date = "dt_txt"
    }
    
    enum MainCodingKeys: String, CodingKey{
        case temp
        case humidity
    }
    
    enum WindCodingKeys: String, CodingKey{
        case speed
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        var mainContainer = container.nestedContainer(keyedBy: MainCodingKeys.self,
                                                         forKey: .main)
        try mainContainer.encode(temperature, forKey: .temp)
        try mainContainer.encode(humidity, forKey: .humidity)
        
        var windContainer = container.nestedContainer(keyedBy: WindCodingKeys.self,
                                                          forKey: .wind)
        try windContainer.encode(windSpeed, forKey: .speed)
        
        let rawWeatherInfo = RawWeatherInfo(weatherId: weatherId, iconCode: iconCode)
        try container.encode(rawWeatherInfo, forKey: .weather)
        
        if let date = date{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            try container.encode(dateFormatter.string(from: date), forKey: .date)
        }
    }
    
    private static func kelvinToCelsius(kelvin: Float) -> Float{
        return kelvin -  273.15
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let mainContainer = try container.nestedContainer(keyedBy: MainCodingKeys.self,
                                                          forKey: .main)
        let kelvin = try mainContainer.decode(Float.self, forKey: .temp)
        
        temperature = Int(Weather.kelvinToCelsius(kelvin: kelvin))
        
        humidity = Int(try mainContainer.decode(Float.self, forKey: .humidity))
        
        let windContainer = try container.nestedContainer(keyedBy: WindCodingKeys.self,
                                                          forKey: .wind)
        windSpeed = try windContainer.decode(Float.self, forKey: .speed)
        
        let rawWeatherInfo = try container.decode([RawWeatherInfo].self, forKey: .weather)
        weatherId = rawWeatherInfo[0].weatherId
        iconCode = rawWeatherInfo[0].iconCode
        (description, icon) = WeatherCodes.getDescriptionAndIcon(weatherId: weatherId, iconCode: iconCode)
        
        if let dateStr = try? container.decode(String.self, forKey: .date){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            date = dateFormatter.date(from: dateStr)!
        } else {
        }
    }
}
