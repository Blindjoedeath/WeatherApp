//
//  LocationInteractorTests.swift
//  WeatherTests
//
//  Created by Oskar on 11/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
@testable import Weather
@testable import Pods_Weather
import RxRelay

class LocationInteractorTests: XCTestCase {
    
    func buildWith(interactor: LocationInteractorProtocol) -> LocationRouterProtocol{
        let configurator = LocationConfigurator()
        configurator.interactor = interactor
        return configurator.build()
    }

    override func setUp() {
    }

    override func tearDown() {
    }

    func testGivenCitySetsWhenPresenterCloses(){
        
        let interactor = LocationInteractorSpy()
        let presenter = buildWith(interactor: interactor).presenter!
        
        let city = "Unexisting city"
        presenter.cityNameChanged(on: city)
        presenter.close()
        
        XCTAssertEqual(interactor.invokedSetCityParameters?.city, city)
    }
    
    func testInteractorShouldReturnCityFromRepository(){
        let city = "Unexisting city"
        let repository = CityRepositoryStub()
        repository.stubbedCity.accept(city)
        
        let interactor = LocationInteractor()
        interactor.cityRepository = CityRepositoryStub.instance
        
        XCTAssertEqual(interactor.getCity(), city)
    }
}
