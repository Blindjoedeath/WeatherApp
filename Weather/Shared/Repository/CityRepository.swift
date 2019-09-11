//
//  CityRepository.swift
//  Weather
//
//  Created by Oskar on 06/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import RxRelay

protocol CityRepositoryProtocol{
    var city: BehaviorRelay<String?> {get}
    static var instance: CityRepositoryProtocol {get}
}

class CityRepository: CityRepositoryProtocol{
    
    static var instance: CityRepositoryProtocol = CityRepository()
    
    let city: BehaviorRelay<String?>
    
    private init(){
        let savedCity = UserDefaults.standard.object(forKey: "city") as? String
        city = BehaviorRelay<String?>(value: savedCity)
        let _ = city.subscribe(onNext: {value in
            UserDefaults.standard.set(value, forKey: "city")
        })
    }
}
