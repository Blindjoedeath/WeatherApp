//
//  CityRepository.swift
//  Weather
//
//  Created by Oskar on 06/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import RxRelay

class CityRepository{
    
    static let instance = CityRepository()
    
    let city: BehaviorRelay<String?>
    
    private init(){
        let savedCity = UserDefaults.standard.object(forKey: "city") as? String
        city = BehaviorRelay<String?>(value: savedCity)
        city.subscribe(onNext: {value in
            UserDefaults.standard.set(value, forKey: "city")
        })
    }
}
