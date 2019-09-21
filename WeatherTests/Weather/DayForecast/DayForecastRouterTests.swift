//
//  DayForecastRouterTests.swift
//  WeatherTests
//
//  Created by Oskar on 20/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
@testable import Weather

class DayForecastRouterTests: XCTestCase {

    var configurator: DayForecastConfigurator!
    
    override func setUp() {
        configurator = DayForecastConfigurator()
    }
    
    override func tearDown() {
        configurator = nil
    }
    
    func testRouterShouldLoadPresenterWhenLoad(){
        let presenter = DayForecastPresenterSpy()
        configurator.presenter = presenter
        let router = configurator.build()
        
        router.load()
        
        XCTAssertTrue(presenter.invokedLoad)
    }
    
    func testRouterShouldUnloadPresenterWhenUnload(){
        let presenter = DayForecastPresenterSpy()
        configurator.presenter = presenter
        let router = configurator.build()
        
        router.unload()
        
        XCTAssertTrue(presenter.invokedUnload)
    }
}
