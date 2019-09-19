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

    func testViewShouldSendSegueWhenPrepare() {
        
        let view = StoryboardView<LocationViewController>().instantiate(withIdentifier: "LocationViewController")
        configurator.view = view
        configurator.presenter = LocationPresenterFake()
        let _ = configurator.build()
        
        let expect = expectation(description: "View should send segue")
        
        let segueHandler: (UIStoryboardSegue) -> () = {segue in
            XCTAssertNotNil(segue)
            expect.fulfill()
        }
        
        view.performSegue(withIdentifier: "WeatherSegue", sender: segueHandler)
        
        waitForExpectations(timeout: 1){error in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
}
