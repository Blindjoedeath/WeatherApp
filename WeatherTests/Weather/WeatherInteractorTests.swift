//
//  WeatherInteractorTests.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 16/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

import XCTest
import RxRelay
import RxSwift
import UIKit
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
    
    func buildInteractorWithWeatherRepositorySpy() -> (WeatherInteractor, WeatherInteractorOutputSpy){
        let weatherRepository = WeatherRepositorySpy()
        let interactorOutput = WeatherInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter?.interactor as! WeatherInteractor
        
        interactor.weatherRepository = weatherRepository
        
        return (interactor, interactorOutput)
    }
    
    func testInteractorShouldRequestDataFromWeatherRepositoryWhenRefresh(){
        let (interactor, _) = buildInteractorWithWeatherRepositorySpy()
        let weatherRepository = interactor.weatherRepository as! WeatherRepositorySpy
        
        let weather = Weather()
        weatherRepository.stubbedGetWeatherResult = Observable.just(weather)
        weatherRepository.stubbedGetForecastResult = Observable.just(Forecast(from: [weather]))
        
        interactor.refreshData()
        
        XCTAssertTrue(weatherRepository.invokedGetWeather)
        XCTAssertTrue(weatherRepository.invokedGetForecast)
    }
    
    func testInteractorShouldSendWeatherToPresenterWhenWeatherFound(){
        let (interactor, interactorOutput) = buildInteractorWithWeatherRepositorySpy()
        let weatherRepository = interactor.weatherRepository as! WeatherRepositorySpy
        
        let weather = Weather()
        weatherRepository.stubbedGetWeatherResult = Observable.just(weather)
        weatherRepository.stubbedGetForecastResult = Observable.just(Forecast(from: [weather]))
                                                               .delay(RxTimeInterval.seconds(10),
                                                                      scheduler: MainScheduler.instance)
        
        interactor.refreshData()
        
        XCTAssertTrue(interactorOutput.invokedFoundWeather)
    }
    
    func testInteractorShouldSendForecastToPresenterWhenForecastFound(){
        let (interactor, interactorOutput) = buildInteractorWithWeatherRepositorySpy()
        let weatherRepository = interactor.weatherRepository as! WeatherRepositorySpy
        
        let weather = Weather()
        weatherRepository.stubbedGetWeatherResult = Observable.just(weather)
                                                              .delay(RxTimeInterval.seconds(10),
                                                                     scheduler: MainScheduler.instance)
        weatherRepository.stubbedGetForecastResult = Observable.just(Forecast(from: [weather]))
        
        interactor.refreshData()
        
        XCTAssertTrue(interactorOutput.invokedFoundDayForecast)
        XCTAssertTrue(interactorOutput.invokedFoundWeekForecast)
    }
    
    func testInteractorShouldCallNoLocationWhenBadResponce(){
        let (interactor, interactorOutput) = buildInteractorWithWeatherRepositorySpy()
        let weatherRepository = interactor.weatherRepository as! WeatherRepositorySpy
        
        let error = ReactiveRequestError.badResponse(code: 666)
        weatherRepository.stubbedGetWeatherResult = Observable.error(error)
        weatherRepository.stubbedGetForecastResult = Observable.error(error)
        
        interactor.refreshData()
        
        XCTAssertTrue(interactorOutput.invokedNoLocation)
    }
    
    func testInteractorShouldCallNoNetworkWhenNoReponce(){
        let (interactor, interactorOutput) = buildInteractorWithWeatherRepositorySpy()
        let weatherRepository = interactor.weatherRepository as! WeatherRepositorySpy
        
        let error = ReactiveRequestError.noResponce
        weatherRepository.stubbedGetWeatherResult = Observable.error(error)
        weatherRepository.stubbedGetForecastResult = Observable.error(error)
        
        interactor.refreshData()
        
        XCTAssertTrue(interactorOutput.invokedNoNetwork)
    }
    
    func testInteractorShouldCallTimeoutWhenTimeoutError(){
        let (interactor, interactorOutput) = buildInteractorWithWeatherRepositorySpy()
        let weatherRepository = interactor.weatherRepository as! WeatherRepositorySpy
        
        let weather = Observable.just(Weather())
                                .delay(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
        let forecast = Observable.just(Forecast(from: [Weather()]))
                                 .delay(RxTimeInterval.seconds(5), scheduler: MainScheduler.instance)
        
        weatherRepository.stubbedGetWeatherResult = weather
        weatherRepository.stubbedGetForecastResult = forecast
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
    
    
    // MARK: Interactor and AppStyleRepository
    
    func testInteractorShouldSetStyleWhenConfigure(){
        let interactorOutput = WeatherInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let _ = configurator.build()
        let interactor = configurator.interactor!
        
        interactor.configure()
        
        XCTAssertTrue(interactorOutput.invokedSetStyle)
    }
    
    func testInteractorShouldGetStyleFromAppStyleRepository(){
        let interactorOutput = WeatherInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let _ = configurator.build()
        let interactor = configurator.interactor as! WeatherInteractor
        let appStyleRepository = AppStyleRepositoryStub()
        let style = AppStyle(name: "test", description: "test", color: .red)
        
        appStyleRepository.stubbedAppStyle = BehaviorRelay<AppStyle>(value: style)
        interactor.styleRepository = appStyleRepository
        interactor.configure()
        
        guard interactorOutput.invokedSetStyle else{
            return XCTFail("Expected set style invoked")
        }
        
        XCTAssertEqual(style, interactorOutput.invokedSetStyleParameters!.appStyle)
    }
}
