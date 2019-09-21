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
        let forecast = Forecast(from: [weather])
        weatherRepository.stubbedWeatherResult = Observable.just(WeatherResult.success(weather))
        weatherRepository.stubbedForecastResult = Observable.just(WeatherResult.success(forecast))
        
        interactor.refreshData()
        
        XCTAssertTrue(weatherRepository.invokedRefreshWeather)
        XCTAssertTrue(weatherRepository.invokedRefreshForecast)
    }
    
    func testInteractorShouldSendWeatherToPresenterWhenWeatherFound(){
        let (interactor, interactorOutput) = buildInteractorWithWeatherRepositorySpy()
        let weatherRepository = interactor.weatherRepository as! WeatherRepositorySpy
        
        let weather = Weather()
        let forecast = Forecast(from: [weather])
        weatherRepository.stubbedWeatherResult = Observable.just(WeatherResult.success(weather))
        weatherRepository.stubbedForecastResult = Observable.just(WeatherResult.success(forecast))
                                                               .delay(RxTimeInterval.seconds(10),
                                                                      scheduler: MainScheduler.instance)
        interactor.configure()
        interactor.refreshData()
        
        XCTAssertTrue(interactorOutput.invokedFoundWeather)
    }
    
    func testInteractorShouldSendForecastToPresenterWhenForecastFound(){
        let (interactor, interactorOutput) = buildInteractorWithWeatherRepositorySpy()
        let weatherRepository = interactor.weatherRepository as! WeatherRepositorySpy
        
        let weather = Weather()
        let forecast = Forecast(from: [weather])
        weatherRepository.stubbedWeatherResult = Observable.just(WeatherResult.success(weather))
                                                           .delay(RxTimeInterval.seconds(10),
                                                                     scheduler: MainScheduler.instance)
        weatherRepository.stubbedForecastResult = Observable.just(WeatherResult.success(forecast))
        
        interactor.configure()
        interactor.refreshData()
        
        XCTAssertTrue(interactorOutput.invokedFoundWeekForecast)
    }
    
    func testInteractorShouldCallNoLocationWhenLocationNotFound(){
        let (interactor, interactorOutput) = buildInteractorWithWeatherRepositorySpy()
        let weatherRepository = interactor.weatherRepository as! WeatherRepositorySpy
        
        weatherRepository.stubbedWeatherResult = Observable.just(WeatherResult<Weather>.locationNotFound)
        weatherRepository.stubbedForecastResult = Observable.just(WeatherResult<Forecast>.locationNotFound)
        
        interactor.configure()
        interactor.refreshData()
        
        XCTAssertTrue(interactorOutput.invokedNoLocation)
    }
    
    func testInteractorShouldCallNoNetworkWhenNoReponce(){
        let (interactor, interactorOutput) = buildInteractorWithWeatherRepositorySpy()
        let weatherRepository = interactor.weatherRepository as! WeatherRepositorySpy
        
        weatherRepository.stubbedWeatherResult = Observable.just(WeatherResult<Weather>.networkError)
        weatherRepository.stubbedForecastResult = Observable.just(WeatherResult<Forecast>.networkError)
        
        interactor.configure()
        interactor.refreshData()
        
        XCTAssertTrue(interactorOutput.invokedNoNetwork)
    }
    
    func testInteractorShouldCallTimeoutWhenTimeoutError(){
        let (interactor, interactorOutput) = buildInteractorWithWeatherRepositorySpy()
        let weatherRepository = interactor.weatherRepository as! WeatherRepositorySpy
        
        weatherRepository.stubbedWeatherResult = Observable.just(WeatherResult<Weather>.timeout)
        weatherRepository.stubbedForecastResult = Observable.just(WeatherResult<Forecast>.timeout)
        
        interactor.configure()
        interactor.refreshData()
        
        XCTAssertTrue(interactorOutput.invokedWeatherRequestTimeOut)
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
        let appStyleRepository = AppStyleRepositorySpy()
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
