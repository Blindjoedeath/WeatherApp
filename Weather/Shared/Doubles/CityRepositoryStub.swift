//
//  CityRepositoryStub.swift
//  Weather
//
//  Created by Oskar on 25/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import RxRelay

class CityRepositoryStub: CityRepositoryProtocol{
    
    var stubbedCity: BehaviorRelay<String?>! = BehaviorRelay(value: "")
    var city: BehaviorRelay<String?> {
        return stubbedCity
    }
}
