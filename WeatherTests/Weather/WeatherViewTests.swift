//
//  WeatherViewTests.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 18/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
@testable import Weather

class WeatherViewTests: XCTestCase {

    var configurator: WeatherConfigurator!
    
    override func setUp() {
        configurator = WeatherConfigurator()
    }
    
    override func tearDown() {
        configurator = nil
    }
    
    func testViewShouldSendSegueToRouter() {
        let router = WeatherRouterSegueMock()
        configurator.router = router
        configurator.view = StoryboardView<WeatherViewController>().instantiate(withIdentifier: "WeatherViewController")
        let _ = configurator.build()
        
        let expect = expectation(description: "View should send segue")
        
        router.segueHandler = {segue in
            XCTAssertNotNil(segue)
            expect.fulfill()
        }
        
        router.route()
        
        waitForExpectations(timeout: 1){error in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }

}
