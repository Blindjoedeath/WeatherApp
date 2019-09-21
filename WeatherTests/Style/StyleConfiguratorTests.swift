//
//  StyleConfiguratorTests.swift
//  WeatherTests
//
//  Created by Oskar on 20/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
@testable import Weather

class StyleConfiguratorTests: XCTestCase {

    var configurator: StyleConfigurator!
    
    override func setUp() {
        configurator = StyleConfigurator()
    }
    
    override func tearDown() {
        configurator = nil
    }
    
    func testModuleConnectionsNotNilWhenViewIsProperty() {
        
        let view = StyleTableViewController()
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
        
        let view = StyleTableViewController()
        
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
