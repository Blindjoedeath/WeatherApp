//
//  CitiesBaseRepositoryStub.swift
//  WeatherTests
//
//  Created by Oskar on 13/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather

class CitiesBaseRespositoryStub: CitiesBaseRepositoryProtocol{
    static var instance: CitiesBaseRepositoryProtocol = CitiesBaseRespositoryStub()
    
    private init(){
        
    }
    
    var stubbedCities: [String]! = []
    var cities: [String] {
        return stubbedCities
    }
}
