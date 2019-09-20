//
//  StyleRouterTests.swift
//  WeatherTests
//
//  Created by Oskar on 20/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
@testable import Weather

class StyleRouterTests: XCTestCase {

    var configurator: StyleConfigurator!
    
    override func setUp() {
        configurator = StyleConfigurator()
    }

    override func tearDown() {
        configurator = nil
    }

    func testRouterShouldDismissViewWhenClose(){
        let view = StyleViewControllerSpy()
        configurator.presenter = StylePresenterFake()
        let router = configurator.build() as! StyleRouter
        
        router.view = view
        router.close()
        
        XCTAssertTrue(view.invokedDissmiss)
    }
}
