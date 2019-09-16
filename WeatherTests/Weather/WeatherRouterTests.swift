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
}



