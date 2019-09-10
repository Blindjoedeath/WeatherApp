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
    
    var router: LocationRouter!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        router = LocationConfigurator.build(with: controller)
        controller.loadView()
    }
    
    override func tearDown() {
        router = nil
    }
    
    func testModuleConnectionsNotNil() {
        
        let presenter = router.presenter
        let view = presenter?.view
        let interactor = router.presenter.interactor
        
        XCTAssertNotNil(router.presenter)
        XCTAssertNotNil(presenter?.router)
        
        XCTAssertNotNil(presenter?.view)
        XCTAssertNotNil((view as? LocationViewController)?.presenter)
        
        XCTAssertNotNil(presenter?.interactor)
        XCTAssertNotNil((interactor as? LocationInteractor)?.output)
    }
}
