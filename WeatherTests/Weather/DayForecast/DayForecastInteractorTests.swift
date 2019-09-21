//
//  DayForecastInteractorTests.swift
//  WeatherTests
//
//  Created by Oskar on 20/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
import RxSwift
import Foundation
@testable import Weather

class DayForecastInteractorTests: XCTestCase {
    
    var configurator: DayForecastConfigurator!
    
    override func setUp() {
        configurator = DayForecastConfigurator()
    }
    
    override func tearDown() {
        configurator = nil
    }
    
    func buildInteractorWithWeatherRepositorySpy() -> (DayForecastInteractor, DayForecastInteractorOutputSpy){
        let weatherRepository = WeatherRepositorySpy()
        let interactorOutput = DayForecastInteractorOutputSpy()
        configurator.interactorOutput = interactorOutput
        let interactor = configurator.build().presenter!.interactor as! DayForecastInteractor
        
        interactor.weatherRepository = weatherRepository
        
        return (interactor, interactorOutput)
    }
    
    
    // MARK: Interactor with WeatherRepository
    
    func testInteractorShouldLoadDataToPresenterWhenConfigure(){
        let (interactor, interactorOutput) = buildInteractorWithWeatherRepositorySpy()
        let weatherRepository = interactor.weatherRepository as! WeatherRepositorySpy
        
        let forecast = Forecast(from: [Weather()])
        let result = WeatherResult.success(forecast)
        weatherRepository.stubbedForecastResult = Observable.just(result)
        interactor.configure()
        
        XCTAssertTrue(interactorOutput.invokedLoad)
    }
    
    func testInteractorShouldLoadOnlyTodayForecast(){
        let (interactor, interactorOutput) = buildInteractorWithWeatherRepositorySpy()
        let weatherRepository = interactor.weatherRepository as! WeatherRepositorySpy
        
        let weather1 = Weather()
        weather1.date = Date()
        let weather2 = Weather()
        weather2.date = Date().addingTimeInterval(99999)
        
        let forecast = Forecast(from: [weather1, weather2])
        let result = WeatherResult.success(forecast)
        weatherRepository.stubbedForecastResult = Observable.just(result)
        interactor.configure()
        
        guard interactorOutput.invokedLoad else {
            return XCTFail("Expected load to be invoked")
        }
        
        let todayForecast = forecast[0]
        XCTAssertEqual(todayForecast, interactorOutput.invokedLoadParameters!.dayForecast)
    }
    
    func testInteractorShouldCallDataReloadWhenForecastLoads(){
        let (interactor, interactorOutput) = buildInteractorWithWeatherRepositorySpy()
        let weatherRepository = interactor.weatherRepository as! WeatherRepositorySpy
        
        let result = WeatherResult<Forecast>.loading
        weatherRepository.stubbedForecastResult = Observable.just(result)
        interactor.configure()
        
        XCTAssertTrue(interactorOutput.invokedDataWillLoad)
    }
}
