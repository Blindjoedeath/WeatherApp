//
//  WeatherConfiguratorTests.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 16/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
import UIKit
@testable import Weather

class WeatherConfiguratorTests: XCTestCase {
    
    var configurator: WeatherConfigurator!
    
    override func setUp() {
        configurator = WeatherConfigurator()
    }
    
    override func tearDown() {
        configurator = nil
    }
    
    func testModuleConnectionsNotNilWhenViewIsProperty() {
        
        let router = configurator.build()
        
        let presenter = configurator?.presenter
        let view = presenter?.view
        let interactor = presenter?.interactor
        
        XCTAssertNotNil(router.presenter)
        XCTAssertNotNil(presenter?.router)
        XCTAssertNotNil(presenter?.view)
        XCTAssertNotNil(view?.presenter)
        XCTAssertNotNil(presenter?.interactor)
        XCTAssertNotNil(interactor?.presenter)
        
    }
    
    func testModuleConnectionsNotNilWhenViewIsParameter() {
        
        let view = WeatherViewController()
        
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

