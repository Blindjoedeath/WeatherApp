//
//  CityRepository.swift
//  Weather
//
//  Created by Oskar on 06/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class CityRepository{
    
    static var instance = CityRepository()
    
    private init(){
        
    }
    
    private var city: String?
    
    func set(city: String){
        self.city = city
        // save city
    }
    
    func getCity() -> String?{
        if let city = city{
            return city
        }
        city = ""
        return city
    }
    
}
