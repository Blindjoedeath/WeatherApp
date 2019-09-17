//
//  LocationViewTests.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 18/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
@testable import Weather

class LocationViewTests: XCTestCase {

    var configurator: LocationConfigurator!
    
    override func setUp() {
        configurator = LocationConfigurator()
    }

    override func tearDown() {
        configurator = nil
    }

    func testViewShouldSendSegueToRouter() {
        let router = LocationRouterSegueMock()
        configurator.router = router
        configurator.view = StoryboardView<LocationViewController>().instantiate(withIdentifier: "LocationViewController")
        let _ = configurator.build()
        
        let expect = expectation(description: "View should send segue")
        
        router.segueHandler = {segue in
            XCTAssertNotNil(segue)
            expect.fulfill()
        }
        
        router.route(with: nil)
        
        waitForExpectations(timeout: 1){error in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
}
