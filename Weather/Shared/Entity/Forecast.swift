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
    
    public func weekAverage() -> [Weather]{
        var result : [Weather] = []
        for i in 0..<self.daysCount{
            let hourBin = self[i].count > 2 ? 2 : self[i].count-1
            result.append(self[i, hourBin])
        }
        return result
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
    
    private static func getDays(from weather: [Weather]) -> [String]{
        var days = [String]()
        weather.map{ w in
            if !days.contains(w.date!.day){
                days.append(w.date!.day)
            }
        }
        return days
    }
    
    private static func sorted(_ weather: [Weather], byDays days: [String]) -> [[Weather]]{
        
        var result: [[Weather]] = []
        days.forEach{ day in
            let oneDayDates = weather.filter { $0.date!.day == day }
            let sorted = oneDayDates.sorted{
                $0.date! < $1.date!
            }
            result.append(sorted)
        }
        
        return result
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let weatherList = try container.decode([Weather].self, forKey: .list)
        
        let days = Forecast.getDays(from: weatherList)
        self.weather = Forecast.sorted(weatherList, byDays: days)
    }
    
    init(from weather: [Weather]){
        let days = Forecast.getDays(from: weather)
        self.weather = Forecast.sorted(weather, byDays: days)
    }
}
