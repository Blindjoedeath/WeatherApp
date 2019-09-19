//
//  CityRepositoryStub.swift
//  WeatherTests
//
//  Created by Oskar on 11/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather
import RxRelay

class CityRepositoryStub: CityRepositoryProtocol{
    var stubbedCity: String!
    
    var city: BehaviorRelay<String?> {
        return BehaviorRelay<String?>(value: stubbedCity)
    }
}
