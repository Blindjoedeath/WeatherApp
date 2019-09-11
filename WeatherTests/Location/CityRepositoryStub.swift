//
//  CityRepositoryStub.swift
//  WeatherTests
//
//  Created by Oskar on 11/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Pods_Weather
@testable import Weather
import RxRelay

class CityRepositoryStub: CityRepositoryProtocol{
    static var instance: CityRepositoryProtocol = CityRepositoryStub()
    
    var stubbedCity: BehaviorRelay<String?>!
    
    var city: BehaviorRelay<String?> {
        return stubbedCity
    }
}
