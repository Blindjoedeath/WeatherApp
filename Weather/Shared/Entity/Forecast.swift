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
    
    public var daysCount: Int {
        get {
            return weather.count
        }
    }
    
    public func getHourBinsCount(for day: Int) -> Int{
        return weather[day].count
    }
    
    subscript(day: Int, hourBin: Int) -> Weather {
        get {
            return weather[day][hourBin]
        }
    }
    
    subscript(day: Int) -> [Weather] {
        get {
            return weather[day]
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
        
        var days = [String]()
        weatherList.map{ w in
            if !days.contains(w.date!.day){
                days.append(w.date!.day)
            }
        }
        
        weather = []
        days.forEach{ day in
            let oneDayDates = weatherList.filter { $0.date!.day == day }
            let sorted = oneDayDates.sorted{
                $0.date! < $1.date!
            }
            
            var multiple :[Weather] = []
            for _ in 1...6{
                multiple += sorted
            }
            multiple = Array(multiple.prefix(24))
            
            weather.append(multiple)
        }
    }
}
