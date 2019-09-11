//
//  LocationRouterTests.swift
//  WeatherTests
//
//  Created by Oskar on 11/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
@testable import Weather

class LocationViewControllerMock: LocationViewController{
    
    var performSegueTriggered = false
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        performSegueTriggered = true
    }
}

class LocationRoutingTests: XCTestCase {
    
    var router: LocationRouterProtocol!
    var controller: LocationViewControllerMock!
    
    override func setUp() {
        let configurator = LocationConfigurator()
        
        controller = LocationViewControllerMock()
        configurator.view = controller
        router = configurator.build()
    }
    
    override func tearDown() {
        router = nil
        controller = nil
    }

    func testPerformSegueTriggersOnRoute() {
        router.route(with: nil)
        
        XCTAssertTrue(controller.performSegueTriggered)
    }
    
    func testViewSendsSegueToRouter(){
        router.route(with: nil)
        
        
    }
}
