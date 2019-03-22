//
//  RawWeatherInfo.swift
//  Weather
//
//  Created by Blind Joe Death on 22/11/2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import Foundation

internal class RawWeatherInfo: Codable{
    var weatherId: Int
    var iconCode: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case icon
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(weatherId, forKey: .id)
        try container.encode(iconCode, forKey: .icon)
    }
    required init(from decoder: Decoder) throws {
        var container = try decoder.container(keyedBy: CodingKeys.self)
        weatherId = try container.decode(Int.self, forKey: .id)
        iconCode = try container.decode(String.self, forKey: .icon)
    }
    
    init(weatherId: Int, iconCode: String){
        self.weatherId = weatherId
        self.iconCode = iconCode
    }
}
