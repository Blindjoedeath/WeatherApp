//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 10/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
import UIKit
@testable import Weather

class LocationConfiguratorTests: XCTestCase {
    
    var configurator: LocationConfigurator!
    
    override func setUp() {
        configurator = LocationConfigurator()
    }
    
    override func tearDown() {
        configurator = nil
    }
    
    func testModuleConnectionsNotNilWhenViewIsProperty() {
        
        let view = LocationViewController()
        
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
    
    func testModuleConnectionsNotNilWhenViewIsParameter() {
        
        let view = LocationViewController()
        
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
