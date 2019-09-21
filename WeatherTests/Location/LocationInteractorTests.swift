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
    
    
    // MARK: Interactor and CityRepository Tests
    
    func testInteractorShouldReturnCityFromRepository(){
        let testCity = "Unexisting city"
        let repository = CityRepositoryStub()
        repository.stubbedCity = testCity
        
        let interactor = LocationInteractor()
        interactor.cityRepository = repository
        
        guard let city = interactor.getCity() else{
            XCTFail("Excected city not to be nil")
            return
        }
        XCTAssertEqual(city, testCity)
    }
    
    
    // MARK: Interactor and GeolocationService Tests
    
    func buildInteractorWithStubbedGeolocationService() -> (LocationInteractor, LocationInteractorOutputSpy){
        let service = GeolocationServiceStub()
        let interactorOutput = LocationInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter?.interactor as! LocationInteractor
        
        interactor.geolocationService = service
        
        return (interactor, interactorOutput)
    }
    
    func testInteractorShouldSendLocalityFromGeolocationService(){
        
        let (interactor, interactorOutput) = buildInteractorWithStubbedGeolocationService()
        let service = interactor.geolocationService as! GeolocationServiceStub
        
        let localityToSend = "Bangladesh"
        service.stubbedGetLocalityResult = Observable<String?>.just(localityToSend)
        interactor.getLocation()
        
        guard interactorOutput.invokedFoundLocality else{
            return XCTFail("Expected found locality to be invoked")
        }
        
        XCTAssertEqual(interactorOutput.invokedFoundLocalityParameters?.locality, localityToSend)
    }
    
    func testInteractorShouldSendErrorWhenGeolocationServiceErrors(){
        
        let (interactor, interactorOutput) = buildInteractorWithStubbedGeolocationService()
        let service = interactor.geolocationService as! GeolocationServiceStub

        service.stubbedGetLocalityResult = Observable.error(CustomError.empty)
        interactor.getLocation()
        
        XCTAssertTrue(interactorOutput.invokedGeolocationError)
    }
    
    func testInteractorShouldSendTimeoutErrorAsyncWhenGeolocationServiceTimeouts(){
        
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
        
        let (interactor, interactorOutput) = buildInteractorWithStubbedGeolocationService()
        let service = interactor.geolocationService as! GeolocationServiceStub
        
        service.stubbedAccess = Observable.just(true)
        interactor.load()
        
        guard interactorOutput.invokedGeolocationAccessDetermined else {
            return XCTFail("Expected geolocation access determined to call")
        }
        
        XCTAssertTrue(interactorOutput.invokedGeolocationAccessDeterminedParameters!.state)
    }
    
    func testInteractorShouldHaveIsAccessDeterminedFromGeolocationService(){
        
        let (interactor, _) = buildInteractorWithStubbedGeolocationService()
        let service = interactor.geolocationService as! GeolocationServiceStub
        
        service.stubbedAccessDetermined = Observable.just(true)
        interactor.load()
        
        XCTAssertTrue(interactor.isLocationAccessDetermined)
    }
    
    
    // MARK: Interactor and WeatherRepository Tests
    
    func buildInteractorWithWeatherRepositorySpy() -> (LocationInteractor, LocationInteractorOutputSpy){
        let weatherRepository = WeatherRepositorySpy()
        let interactorOutput = LocationInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter?.interactor as! LocationInteractor
        
        interactor.weatherRepository = weatherRepository
        
        return (interactor, interactorOutput)
    }
    
    func testInteractorShouldSaveCityToRepositoryWhenWeatherFound(){
        
        let (interactor, _) = buildInteractorWithWeatherRepositorySpy()
        let cityRepository = CityRepositoryFake()
        let weatherRepository = interactor.weatherRepository as! WeatherRepositorySpy
        let locality = "Бангладеш"
        
        let weather = WeatherResult.success(Weather())
        weatherRepository.stubbedWeatherResult = Observable.just(weather)
        interactor.cityRepository = cityRepository
        interactor.getWeather(for: locality)
        
        guard let city = cityRepository.city.value else{
            return XCTFail("Expected city not to be nil")
        }
        
        XCTAssertEqual(city, locality)
    }
    func testInteractorShouldCallPresenterWhenFoundWeather(){
        let (interactor, interactorOutput) = buildInteractorWithWeatherRepositorySpy()
        let weatherRepository = interactor.weatherRepository as! WeatherRepositorySpy
        
        let weather = WeatherResult<Weather>.success(Weather())
        weatherRepository.stubbedWeatherResult = Observable.just(weather)
        interactor.getWeather(for: "dummy")
        
        XCTAssertTrue(interactorOutput.invokedFoundWeather)
    }
    
    func testInteractorShouldCallPresenterWhenNoFoundLocation(){
        let (interactor, interactorOutput) = buildInteractorWithWeatherRepositorySpy()
        let weatherRepository = interactor.weatherRepository as! WeatherRepositorySpy
        
        let result = WeatherResult<Weather>.locationNotFound
        weatherRepository.stubbedWeatherResult = Observable.just(result)
        interactor.getWeather(for: "dummy")
        
        XCTAssertTrue(interactorOutput.invokedNoLocation)
    }
    
    func testInteractorShouldCallPresenterWhenNoNetwork(){
        let (interactor, interactorOutput) = buildInteractorWithWeatherRepositorySpy()
        let weatherRepository = interactor.weatherRepository as! WeatherRepositorySpy
        
        let result = WeatherResult<Weather>.networkError
        weatherRepository.stubbedWeatherResult = Observable.just(result)
        interactor.getWeather(for: "dummy")
        
        XCTAssertTrue(interactorOutput.invokedNoNetwork)
    }
    
    func testInteractorShouldCallPresenterWhenTimeout(){
        let (interactor, interactorOutput) = buildInteractorWithWeatherRepositorySpy()
        let weatherRepository = interactor.weatherRepository as! WeatherRepositorySpy
        
        weatherRepository.stubbedWeatherResult = Observable.just(WeatherResult<Weather>.timeout)
        
        interactor.getWeather(for: "dummy")

        XCTAssertTrue(interactorOutput.invokedWeatherRequestTimeOut)
    }
    
}
