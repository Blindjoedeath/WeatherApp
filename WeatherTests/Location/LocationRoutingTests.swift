//
//  LocationRouterTests.swift
//  WeatherTests
//
//  Created by Oskar on 11/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
@testable import Weather


class LocationRoutingTests: XCTestCase {
    
    var configurator: LocationConfigurator!
    
    override func setUp() {
        configurator = LocationConfigurator()
    }
    
    override func tearDown() {
        configurator = nil
    }

    func testPerformSegueTriggersWhenRoute() {
        let controller = LocationViewControllerSegueMock()
        configurator.view = controller
        let router = configurator.build()
        
        router.route(with: nil)
        
        XCTAssertTrue(controller.performSegueTriggered)
    }
}
