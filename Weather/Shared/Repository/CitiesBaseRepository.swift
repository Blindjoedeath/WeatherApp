//
//  CityRepository.swift
//  Weather
//
//  Created by Oskar on 04/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class CitiesBaseRepository{
    
    static let instance = CitiesBaseRepository()
    
    private init(){
        
    }
    
    var cities: [String] = {
        var cities = [""]
        if let data = CsvReader.read(file: "geo"){
            for row in data{
                if row.count > 6 {
                    cities.append(row[6])
                }
            }
        }
        return cities
    }()
}
