//
//  WeatherRouterTests.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 16/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
@testable import Weather


class WeatherRoutingTests: XCTestCase {
    
    var configurator: WeatherConfigurator!
    
    override func setUp() {
        configurator = WeatherConfigurator()
    }
    
    override func tearDown() {
        configurator = nil
    }
    
    func testPerformSegueTriggersWhenRoute() {
        let controller = WeatherViewControllerMock()
        let router = configurator.build(with: controller)
        
        router.route()
        
        XCTAssertTrue(controller.performSegueTriggered)
    }
    
    func testRouterShouldLoadDayForecastRouterWhenPresent(){
        let dayForecastRouter = DayForecastRouterSpy()
        let router = configurator.build() as! WeatherRouter
        
        router.dayForecastRouter = dayForecastRouter
        router.presentDayForecast()
        
        XCTAssertTrue(dayForecastRouter.invokedLoad)
    }
    
    func testRouterShouldUnloadDayForecastRouterWhenUnload(){
        let dayForecastRouter = DayForecastRouterSpy()
        let view = WeatherViewController()
        configurator.view = view
        let router = configurator.build() as! WeatherRouter
        
        router.dayForecastRouter = dayForecastRouter
        router.unload()
        
        XCTAssertTrue(dayForecastRouter.invokedUnload)
    }
}



