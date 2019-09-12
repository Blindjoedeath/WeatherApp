//
//  CityRepositoryFake.swift
//  WeatherTests
//
//  Created by Oskar on 12/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather
import RxRelay

class CityRepositoryFake: CityRepositoryProtocol{
    static var instance: CityRepositoryProtocol = CityRepositoryFake()
    
    private init(){
    }
    
    var city = BehaviorRelay<String?>(value: nil)
}
