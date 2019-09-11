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
    
    var router: LocationRouterProtocol!
    var controller: LocationViewProtocol!
    
    override func setUp() {
        let configurator = LocationConfigurator()
        
        controller = LocationViewController()
        configurator.view = controller
        router = configurator.build()
    }
    
    override func tearDown() {
        router = nil
        controller = nil
    }
    
    func testModuleConnectionsNotNil() {
        
        let presenter = router?.presenter
        let view = presenter?.view
        let interactor = presenter?.interactor
        
        XCTAssertNotNil(router?.presenter)
        XCTAssertNotNil(presenter?.router)
        
        XCTAssertNotNil(presenter?.view)
        XCTAssertNotNil(view?.presenter)
        
        XCTAssertNotNil(presenter?.interactor)
        XCTAssertNotNil(interactor?.presenter)
        
    }
}
