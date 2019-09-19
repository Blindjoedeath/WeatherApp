//
//  WeatherInteractorTests.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 16/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

import XCTest
import RxSwift
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
        let repository = CityRepositoryStub()
        repository.stubbedCity = testCity
        
        let interactor = WeatherInteractor()
        interactor.cityRepository = repository
        
        let city = interactor.getCity()
        XCTAssertEqual(city, testCity)
    }
    
    
    // MARK: Interactor and WeatherRepository tests
    
    func testInteractorShouldRequestDataFromWeatherRepositoryWhenRefresh(){
        let weatherRepository = WeatherRepositorySpy()
        configurator.interactorOutput = WeatherInteractorOutputFake()
        let interactor = configurator.build().presenter!.interactor as! WeatherInteractor
        
        let weather = Weather()
        weatherRepository.stubbedGetWeatherResult = Observable.just(weather)
        weatherRepository.stubbedGetForecastResult = Observable.just(Forecast(from: [weather]))
        interactor.weatherRepository = weatherRepository
        
        interactor.refreshData()
        
        XCTAssertTrue(weatherRepository.invokedGetWeather)
        XCTAssertTrue(weatherRepository.invokedGetForecast)
    }
    
    func testInteractorShouldSendWeatherToPresenterWhenWeatherFound(){
        let weatherRepository = WeatherRepositorySpy()
        let interactorOutput = WeatherInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter!.interactor as! WeatherInteractor
        
        let weather = Weather()
        weatherRepository.stubbedGetWeatherResult = Observable.just(weather)
        weatherRepository.stubbedGetForecastResult = Observable.just(Forecast(from: [weather]))
                                                               .delay(RxTimeInterval.seconds(10),
                                                                      scheduler: MainScheduler.instance)
        interactor.weatherRepository = weatherRepository
        
        interactor.refreshData()
        
        XCTAssertTrue(interactorOutput.invokedFoundWeather)
    }
    
    func testInteractorShouldSendForecastToPresenterWhenForecastFound(){
        let weatherRepository = WeatherRepositorySpy()
        let interactorOutput = WeatherInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter!.interactor as! WeatherInteractor
        
        let weather = Weather()
        weatherRepository.stubbedGetWeatherResult = Observable.just(weather)
                                                              .delay(RxTimeInterval.seconds(10),
                                                                     scheduler: MainScheduler.instance)
        weatherRepository.stubbedGetForecastResult = Observable.just(Forecast(from: [weather]))
        interactor.weatherRepository = weatherRepository
        
        interactor.refreshData()
        
        XCTAssertTrue(interactorOutput.invokedFoundDayForecast)
        XCTAssertTrue(interactorOutput.invokedFoundWeekForecast)
    }
    
    func testInteractorShouldCallNoLocationWhenBadResponce(){
        let weatherRepository = WeatherRepositorySpy()
        let interactorOutput = WeatherInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter!.interactor as! WeatherInteractor
        
        let error = ReactiveRequestError.badResponse(code: 666)
        weatherRepository.stubbedGetWeatherResult = Observable.error(error)
        weatherRepository.stubbedGetForecastResult = Observable.error(error)
        interactor.weatherRepository = weatherRepository
        
        interactor.refreshData()
        
        XCTAssertTrue(interactorOutput.invokedNoLocation)
    }
    
    func testInteractorShouldCallNoNetworkWhenNoReponce(){
        let weatherRepository = WeatherRepositorySpy()
        let interactorOutput = WeatherInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter!.interactor as! WeatherInteractor
        
        let error = ReactiveRequestError.noResponce
        weatherRepository.stubbedGetWeatherResult = Observable.error(error)
        weatherRepository.stubbedGetForecastResult = Observable.error(error)
        interactor.weatherRepository = weatherRepository
        
        interactor.refreshData()
        
        XCTAssertTrue(interactorOutput.invokedNoNetwork)
    }
    
    func testInteractorShouldCallTimeoutWhenTimeoutError(){
        let weatherRepository = WeatherRepositorySpy()
        let interactorOutput = WeatherInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter!.interactor as! WeatherInteractor
        
        let weather = Observable.just(Weather())
                                .delay(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
        let forecast = Observable.just(Forecast(from: [Weather()]))
                                 .delay(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
        
        weatherRepository.stubbedGetWeatherResult = weather
        weatherRepository.stubbedGetForecastResult = forecast
        interactor.weatherRepository = weatherRepository
        interactor.timeLimit = 0
        
        interactor.refreshData()

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
