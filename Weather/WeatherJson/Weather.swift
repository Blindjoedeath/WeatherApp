//
//  Weather.swift
//  Weather
//
//  Created by Blind Joe Death on 08/11/2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import Foundation

class Weather: Codable {
    var temperature: Float
    var humidity: Float
    var type: String
    var description: String
    var date: Date?
    private var windSpeed: Float
    
    var perceivedTemperature: Int {
        return 5
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
        
        let rawWeatherInfo = RawWeatherInfo(type: type, description: description)
        try container.encode(rawWeatherInfo, forKey: .weather)
        
        if let date = date{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            try container.encode(dateFormatter.string(from: date), forKey: .date)
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let mainContainer = try container.nestedContainer(keyedBy: MainCodingKeys.self,
                                                          forKey: .main)
        temperature = try mainContainer.decode(Float.self, forKey: .temp)
        humidity = try mainContainer.decode(Float.self, forKey: .humidity)
        
        let windContainer = try container.nestedContainer(keyedBy: WindCodingKeys.self,
                                                          forKey: .wind)
        windSpeed = try windContainer.decode(Float.self, forKey: .speed)
        
        let rawWeatherInfo = try container.decode([RawWeatherInfo].self, forKey: .weather)
        type = rawWeatherInfo[0].type
        description = rawWeatherInfo[0].description
        
        if let dateStr = try? container.decode(String.self, forKey: .date){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            date = dateFormatter.date(from: dateStr)!
        } else {
            print("LOL")
        }
    }
}
