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
        let repository = CityRepositoryStub.instance as! CityRepositoryStub
        repository.stubbedCity = testCity
        
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
        let service = GeolocationServiceStub()
        let interactorOutput = LocationInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter?.interactor as! LocationInteractor
        
        interactor.geolocationService = service
        service.stubbedGetLocalityResult = Observable<String?>.just(localityToSend)
        interactor.getLocation()
        
        guard interactorOutput.invokedFoundLocality else{
            return XCTFail("Expected found locality to be invoked")
        }
        
        XCTAssertEqual(interactorOutput.invokedFoundLocalityParameters?.locality, localityToSend)
    }
    
    func testInteractorShouldSendErrorWhenGeolocationServiceErrors(){
        
        let service = GeolocationServiceStub()
        let interactorOutput = LocationInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter?.interactor as! LocationInteractor

        interactor.geolocationService = service
        service.stubbedGetLocalityResult = Observable.error(CustomError.empty)
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
        
        let service = GeolocationServiceStub()
        
        let interactorOutput = LocationInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter?.interactor as! LocationInteractor
        
        interactor.geolocationService = service
        service.stubbedAccess = Observable.just(true)
        interactor.load()
        
        guard interactorOutput.invokedGeolocationAccessDetermined else {
            return XCTFail("Expected geolocation access determined to call")
        }
        
        XCTAssertTrue(interactorOutput.invokedGeolocationAccessDeterminedParameters!.state)
    }
    
    func testInteractorShouldHaveIsAccessDeterminedFromGeolocationService(){
        
        let service = GeolocationServiceStub()
        let interactorOutput = LocationInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter?.interactor as! LocationInteractor
        
        interactor.geolocationService = service
        service.stubbedAccessDetermined = Observable.just(true)
        interactor.load()
        
        XCTAssertTrue(interactor.isLocationAccessDetermined)
    }
    
    
    func testInteractorShouldSaveCityToRepositoryWhenWeatherFound(){
        
        let locality = "Бангладеш"
        let cityRepository = CityRepositoryFake.instance
        let weatherRepository = WeatherRepositoryStub.instance as! WeatherRepositoryStub
        configurator.view = LocationViewFake()
        let interactor = configurator.build().presenter?.interactor as! LocationInteractor
        
        weatherRepository.stubbedGetWeatherResult = Observable.just(Weather())
        interactor.weatherRepository = weatherRepository
        interactor.cityRepository = cityRepository
        interactor.getWeather(for: locality)
        
        guard let city = cityRepository.city.value else{
            return XCTFail("Expected city not to be nil")
        }
        
        XCTAssertEqual(city, locality)
    }
    
    func testInteractorShouldCallPresenterWhenFoundWeather(){
        let weatherRepository = WeatherRepositoryStub.instance as! WeatherRepositoryStub
        let interactorOutput = LocationInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter?.interactor as! LocationInteractor
        
        weatherRepository.stubbedGetWeatherResult = Observable.just(Weather())
        interactor.weatherRepository = weatherRepository
        interactor.getWeather(for: "dummy")
        
        XCTAssertTrue(interactorOutput.invokedFoundWeather)
    }
    
    func testInteractorShouldCallPresenterWhenWeatherObservableSendsNoLocation(){
        let weatherRepository = WeatherRepositoryStub.instance as! WeatherRepositoryStub
        let interactorOutput = LocationInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter?.interactor as! LocationInteractor
        
        let error = ReactiveRequestError.badResponse(code: 666)
        weatherRepository.stubbedGetWeatherResult = Observable.error(error)
        interactor.weatherRepository = weatherRepository
        interactor.getWeather(for: "dummy")
        
        XCTAssertTrue(interactorOutput.invokedNoLocation)
    }
    
    func testInteractorShouldCallPresenterWhenWeatherObservableSendsNoNetwork(){
        let weatherRepository = WeatherRepositoryStub.instance as! WeatherRepositoryStub
        let interactorOutput = LocationInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter?.interactor as! LocationInteractor
        
        let error = ReactiveRequestError.noResponce
        weatherRepository.stubbedGetWeatherResult = Observable.error(error)
        interactor.weatherRepository = weatherRepository
        interactor.getWeather(for: "dummy")
        
        XCTAssertTrue(interactorOutput.invokedNoNetwork)
    }
    
    func testInteractorShouldCallPresenterWhenWeatherObservableSendsTimeout(){
        let weatherRepository = WeatherRepositoryStub.instance as! WeatherRepositoryStub
        let interactorOutput = LocationInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter?.interactor as! LocationInteractor
        
        let result = Observable.just(Weather())
                               .delay(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
        weatherRepository.stubbedGetWeatherResult = result
        interactor.weatherRepository = weatherRepository
        interactor.requestTimeout = 0
        interactor.getWeather(for: "dummy")
        
        let expect = expectation(description: "Expect weather request time out")
        
        interactorOutput.weatherRequestTimeOutHandler = {
            XCTAssertTrue(interactorOutput.invokedWeatherRequestTimeOut)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
}
