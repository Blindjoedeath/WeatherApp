//
//  LocationRouterTests.swift
//  WeatherTests
//
//  Created by Oskar on 11/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
import UIKit
@testable import Weather

class LocationViewControllerSegueMock: LocationViewController{
    
    var performSegueTriggered = false
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        performSegueTriggered = true
    }
}

class LocationRouterSegueMock: LocationRouter{
    var receivedSegue: UIStoryboardSegue!
    
    override func nextModuleFrom(segue: UIStoryboardSegue, with data: Any?) {
        receivedSegue = segue
    }
}

class LocationRoutingTests: XCTestCase {
    
    var configurator = LocationConfigurator()
    
    override func setUp() {
    }
    
    override func tearDown() {
    }

    func testPerformSegueTriggersWhenRoute() {
        let controller = LocationViewControllerSegueMock()
        configurator.view = controller
        let router = configurator.build()
        
        router.route(with: nil)
        
        XCTAssertTrue(controller.performSegueTriggered)
    }
    
    func testViewSendsSegueToRouter(){
        let controller = TestView<LocationViewController>().instantiate(withIdentifier: "LocationViewController")
        var router = LocationRouterSegueMock()
        configurator.view = controller
        configurator.router = router
        router = configurator.build() as! LocationRouterSegueMock
        
        router.route(with: nil)
        XCTAssertNotNil(router.receivedSegue)
    }

}
