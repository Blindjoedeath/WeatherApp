//
//  WeatherInteractorTests.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 16/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

import XCTest
@testable import Weather

class WeatherInteractorTests: XCTestCase {
    
    var configurator: WeatherConfigurator!
    
    override func setUp() {
        configurator = WeatherConfigurator()
    }
    
    override func tearDown() {
        configurator = nil
    }
    
    // MARK: Interactor and CityRepository tests
    
    func testInteractorShouldReturnCityFromRepository(){
        let testCity = "Unexisting city"
        let repository = CityRepositoryStub.instance as! CityRepositoryStub
        repository.stubbedCity = testCity
        
        let interactor = WeatherInteractor()
        interactor.cityRepository = repository
        
        let city = interactor.getCity()
        XCTAssertEqual(city, testCity)
    }
}
