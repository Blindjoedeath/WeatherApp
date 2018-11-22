//
//  RawWeatherInfo.swift
//  Weather
//
//  Created by Blind Joe Death on 22/11/2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import Foundation

class RawWeatherInfo: Codable{
    var type: String
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case type = "main"
        case description
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(description, forKey: .description)
    }
    required init(from decoder: Decoder) throws {
        var container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        description = try container.decode(String.self, forKey: .description)
    }
    
    init(type t: String, description d: String){
        type = t
        description = d
    }
}
