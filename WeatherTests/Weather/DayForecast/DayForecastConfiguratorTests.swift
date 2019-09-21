//
//  DayForecastConfiguratorTests.swift
//  WeatherTests
//
//  Created by Oskar on 20/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
import UIKit
@testable import Weather

class DayForecastConfiguratorTests: XCTestCase {
    
    var configurator: DayForecastConfigurator!
    
    override func setUp() {
        configurator = DayForecastConfigurator()
    }
    
    override func tearDown() {
        configurator = nil
    }
    
    func testModuleConnectionsNotNilWhenViewIsProperty() {
        
        let view = DayForecastViewController()
        configurator.view = view
        let router = configurator.build()
        
        let presenter = configurator?.presenter
        let interactor = presenter?.interactor
        
        XCTAssertNotNil(router.presenter)
        XCTAssertNotNil(presenter?.router)
        XCTAssertNotNil(presenter?.view)
        XCTAssertNotNil(view.presenter)
        XCTAssertNotNil(presenter?.interactor)
        XCTAssertNotNil(interactor?.presenter)
        
    }
    
    func testModuleConnectionsNotNilWhenViewIsParameter() {
        
        let view = DayForecastViewController()
        
        let router = configurator.build(with: view)
        let presenter = configurator?.presenter
        let interactor = presenter?.interactor
        
        XCTAssertNotNil(router.presenter)
        XCTAssertNotNil(presenter?.router)
        XCTAssertNotNil(presenter?.view)
        XCTAssertNotNil(view.presenter)
        XCTAssertNotNil(presenter?.interactor)
        XCTAssertNotNil(interactor?.presenter)
        
    }
}


