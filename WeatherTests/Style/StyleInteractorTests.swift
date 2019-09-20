//
//  StyleInteractorTests.swift
//  WeatherTests
//
//  Created by Oskar on 20/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
import RxRelay
import UIKit
@testable import Weather

class StyleInteractorTests: XCTestCase {

    var configurator: StyleConfigurator!
    
    override func setUp() {
        configurator = StyleConfigurator()
    }

    override func tearDown() {
        configurator = nil
    }

    func testInteractorShouldReturnStyleFromStyleRepository(){
        let styleRepository = AppStyleRepositorySpy()
        configurator.interactorOutput = StyleInteractorOutputFake()
        let interactor = configurator.build().presenter!.interactor as! StyleInteractor
        
        let stubbedStyle = AppStyle(name: "test", description: "test1", color: .red)
        styleRepository.stubbedAppStyle = BehaviorRelay(value: stubbedStyle)
        interactor.styleRepository = styleRepository
        
        let style = interactor.getStyle()
        XCTAssertEqual(style, stubbedStyle)
    }
    
    func testInteractorShouldReturnAppStylesFromRepository(){
        let styleRepository = AppStyleRepositorySpy()
        configurator.interactorOutput = StyleInteractorOutputFake()
        let interactor = configurator.build().presenter!.interactor as! StyleInteractor
        
        let style1 = AppStyle(name: "notest", description: "notest1", color: .blue)
        let style2 = AppStyle(name: "test", description: "test1", color: .red)
        let stubbedStyles = [style1.name : style1, style2.name : style2]
        styleRepository.stubbedAppStyles = stubbedStyles
        interactor.styleRepository = styleRepository
        
        let styles = interactor.getAllStyles()
        let stubbedValues = stubbedStyles.map{$0.value}
        XCTAssertEqual(styles, stubbedValues)
    }
    
    func testInteractorShouldSetStyleToStyleRepositoryWhenSetStyle(){
        let styleRepository = AppStyleRepositorySpy()
        configurator.interactorOutput = StyleInteractorOutputFake()
        let interactor = configurator.build().presenter!.interactor as! StyleInteractor
        let oldStyle = AppStyle(name: "notest", description: "notest1", color: .blue)
        let newStyle = AppStyle(name: "test", description: "test1", color: .red)
        styleRepository.stubbedAppStyle = BehaviorRelay(value: oldStyle)
        styleRepository.stubbedAppStyles = [oldStyle.name : oldStyle,
                                            newStyle.name : newStyle]
        
        interactor.styleRepository = styleRepository
        interactor.setStyle(name: newStyle.name)
        
        let savedStyle = styleRepository.appStyle.value
        XCTAssertEqual(savedStyle, newStyle)
    }
}
