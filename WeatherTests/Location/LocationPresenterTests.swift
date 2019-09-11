//
//  LocationPresenterTests.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 11/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
@testable import Weather

class LocationPresenterTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }
    
    func build(with interactor: LocationInteractorProtocol) -> LocationRouterProtocol{
        let configurator = LocationConfigurator()
        configurator.interactor = interactor
        return configurator.build()
    }

    func testPresenterShouldSetCityToInteractorWhenCloses(){
        
        let interactor = LocationInteractorSpy()
        let presenter = build(with: interactor).presenter!
        
        let city = "Unexisting city"
        presenter.cityNameChanged(on: city)
        presenter.close()
        
        guard interactor.invokedSetCity else{
            return XCTFail("Expected set city to be invoked")
        }
        XCTAssertEqual(interactor.invokedSetCityParameters?.city, city)
    }

}
