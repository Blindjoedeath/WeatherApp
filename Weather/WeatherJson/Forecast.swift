//
//  Forecast.swift
//  Weather
//
//  Created by Blind Joe Death on 22/11/2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import Foundation

class Forecast: Codable{
    
    private var weather: [[Weather]]
    
    subscript(day: Int, hourBin: Int) -> Weather {
        get {
            return weather[day][hourBin]
        }
    }
    
    enum CodingKeys: String, CodingKey{
        case list
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(weather.reduce([], +), forKey: .list)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let weatherList = try container.decode([Weather].self, forKey: .list)
        
        weather = []
        weatherList.forEach{
            let dateKey = $0.date!.day()
            let filterArray = weatherList.filter { $0.date!.day() == dateKey }
            let sorted = filterArray.sorted{
                $0.date! < $1.date!
            }
            weather.append(sorted)
        }
    }
}
