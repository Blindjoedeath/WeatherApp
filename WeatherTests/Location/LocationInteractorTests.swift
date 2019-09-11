//
//  LocationInteractorTests.swift
//  WeatherTests
//
//  Created by Oskar on 11/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
@testable import Weather
import RxRelay
import RxSwift

enum CustomError: Error{
    case empty
}

class LocationInteractorTests: XCTestCase {
    
    var configurator: LocationConfigurator!
    
    override func setUp() {
        configurator = LocationConfigurator()
    }

    override func tearDown() {
        configurator = nil
    }
    
    func testInteractorShouldReturnCityFromRepository(){
        let testCity = "Unexisting city"
        let repository = CityRepositoryFake.instance
        repository.city.accept(testCity)
        
        let interactor = LocationInteractor()
        interactor.cityRepository = repository
        
        guard let city = interactor.getCity() else{
            XCTFail("Excected city not to be nil")
            return
        }
        XCTAssertEqual(city, testCity)
    }
    
    func testInteractorShouldSendLocalityFromGeolocationService(){
        
        let localityToSend = "Бангладеш"
        let service = GeolocationServiceLocalityStub()
        let interactorOutput = LocationInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter?.interactor as! LocationInteractor
        
        interactor.geolocationService = service
        service.localityToSend = localityToSend
        interactor.getLocation()
        
        guard interactorOutput.invokedFoundLocality else{
            return XCTFail("Expected found locality to be invoked")
        }
        
        XCTAssertEqual(interactorOutput.invokedFoundLocalityParameters?.locality, localityToSend)
    }
    
    func testInteractorShouldSendErrorWhenGeolocationServiceErrors(){
        
        let service = GeolocationServiceErrorStub()
        let interactorOutput = LocationInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter?.interactor as! LocationInteractor

        interactor.geolocationService = service
        service.errorToSend = CustomError.empty
        interactor.getLocation()
        
        XCTAssertTrue(interactorOutput.invokedGeolocationError)
    }
    
    func testInteractorShouldSendTimeoutErrorWhenGeolocationServiceTimeouts(){
        
        let interactorOutput = LocationInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter?.interactor as! LocationInteractor
        
        interactor.geolocationService.timeLimit = 0
        interactor.getLocation()
        
        let expect = expectation(description: "Expect geolocation timeout called")
        
        interactorOutput.geolocationTimeOutHandler = {
            XCTAssertTrue(interactorOutput.invokedGeolocationTimeOut)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testInteractorShouldSendAccessFromGeolocationService(){
        
        let service = GeolocationServiceAccessStub()
        
        let interactorOutput = LocationInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter?.interactor as! LocationInteractor
        
        interactor.geolocationService = service
        service.setAccess(true)
        
        guard interactorOutput.invokedGeolocationAccessDetermined else {
            return XCTFail("Expected geolocation access determined to call")
        }
        
        XCTAssertTrue(interactorOutput.invokedGeolocationAccessDeterminedParameters!.state)
    }
}
