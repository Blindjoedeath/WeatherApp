//
//  StylePresenterTests.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 21/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
@testable import Weather

class StylePresenterTests: XCTestCase {

    var configurator: StyleConfigurator!
    
    override func setUp() {
        configurator = StyleConfigurator()
    }
    
    override func tearDown() {
        configurator = nil
    }
    
    func testPresenterShouldConfigureInteractorWhenLoad(){
        let interactor = StyleInteractorSpy()
        configurator.interactor = interactor
        configurator.view = StyleViewControllerFake()
        let presenter = configurator.build().presenter!
        
        presenter.load()
        
        XCTAssertTrue(interactor.invokedConfigure)
    }
    
    func testPresenterShouldSetStyleToInteractor(){
        let interactor = StyleInteractorSpy()
        configurator.interactor = interactor
        configurator.view = StyleViewControllerFake()
        let presenter = configurator.build().presenter!
        let styleName = "Metrosexual"
        
        presenter.styleChanged(name: styleName)
        
        guard interactor.invokedSetStyle else {
            return XCTFail("Expected set style to be invoked")
        }
        
        XCTAssertEqual(styleName, interactor.invokedSetStyleParameters?.name)
    }
    
    func testPresenterShouldSetAllStylesToView(){
        let view = StyleViewControllerSpy()
        let interactor = StyleInteractorSpy()
        configurator.interactor = interactor
        configurator.view = view
        let presenter = configurator.build().presenter!
        
        let style = AppStyle(name: "test", description: "test1", color: .green)
        let appStyles = [style]
        interactor.stubbedGetAllStylesResult = appStyles
        
        presenter.load()
        
        guard view.invokedSetItems else {
            return XCTFail("Expected set items to be invoked")
        }
        
        XCTAssertEqual(appStyles, view.invokedSetItemsParameters?.items)
    }
}
