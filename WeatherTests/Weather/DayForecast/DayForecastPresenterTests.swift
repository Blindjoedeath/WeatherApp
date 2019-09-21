//
//  DayForecastPresenterTests.swift
//  WeatherTests
//
//  Created by Oskar on 20/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
@testable import Weather

class DayForecastPresenterTests: XCTestCase {
    
    var configurator: DayForecastConfigurator!
    
    override func setUp() {
        configurator = DayForecastConfigurator()
    }
    
    override func tearDown() {
        configurator = nil
    }
    
    
    // MARK: Presenter with Interactor
    
    func testPresenterShouldConfigureInteractorWhenLoad(){
        let interactor = DayForecastInteractorySpy()
        configurator.view = DayForecastViewFake()
        configurator.interactor = interactor
        let presenter = configurator.build().presenter!
        
        presenter.load()
        
        XCTAssertTrue(interactor.invokedConfigure)
    }
    
    
    // MARK: Presenter with View
    
    func buildPresenterWithViewSpy() -> (DayForecastPresenter, DayForecastViewSpy){
        let view = DayForecastViewSpy()
        configurator.view = view
        configurator.interactor = DayForecastInteractorFake()
        let presenter = configurator.build().presenter as! DayForecastPresenter
        
        return (presenter, view)
    }
    
    func testPresenterShouldEnableIndicatorWhenLoads(){
        let (presenter, view) = buildPresenterWithViewSpy()
        presenter.load()
        XCTAssertTrue(view.invokedIsUpdatingIndicatorEnabled!)
    }
    
    func testPresenterShouldCancelAnimationWhenUnload(){
        let (presenter, view) = buildPresenterWithViewSpy()
        presenter.unload()
        XCTAssertTrue(view.invokedCancelAnimation)
    }
    
    
    // MARK: Presenter as InteractorOutput
    
    func testPresenterShouldEnableIndicatorWhenDataWillLoad(){
        let (presenter, view) = buildPresenterWithViewSpy()
        presenter.dataWillLoad()
        XCTAssertTrue(view.invokedIsUpdatingIndicatorEnabled!)
    }
    
    func testPresenterShouldDisableIndicatorWhenLoadData(){
        let (presenter, view) = buildPresenterWithViewSpy()
        presenter.load(dayForecast: [])
        XCTAssertFalse(view.invokedIsUpdatingIndicatorEnabled!)
    }
    
    func testPresenterShouldCreateWeatherItemsWithHoursAsDate(){
        let (presenter, view) = buildPresenterWithViewSpy()
        
        let weather1 = Weather()
        weather1.date = Date()
        weather1.description = "test"
        
        let weather2 = Weather()
        weather2.date = Date().addingTimeInterval(9999)
        weather2.description = "test2"
        
        let dayForecast = [weather1, weather2]
        presenter.load(dayForecast: dayForecast)
        
        let items = dayForecast.map{ WeatherItem.from(weather: $0, date: $0.date!.hour)}
        
        guard view.invokedLoad else {
            return XCTFail("Expected load to be invoked")
        }
        
        XCTAssertEqual(items, view.invokedLoadParameters!.dayForecast)
    }
}
