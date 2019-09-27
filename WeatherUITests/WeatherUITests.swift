//
//  WeatherUITests.swift
//  WeatherUITests
//
//  Created by Oskar on 27/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest

class WeatherUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        
        XCUIApplication().launch()
    }
    
    func launchWeatherScreen() -> XCUIApplication{
        let app = XCUIApplication()
        app.buttons["DefineLocationButton"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["NextButton"]/*[[".buttons[\"Далее\"]",".buttons[\"NextButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        return app
    }
    
    func scrollUp(){
        let app = XCUIApplication()
        let scrollView = app.scrollViews.firstMatch
        DispatchQueue.main.async {
            scrollView.swipeDown()
        }
    }
    
    
    // MARK: On load
    
    func testKuranovSpinnerShouldAppearOnLoad(){
        let app = launchWeatherScreen()
        let spinner = app.otherElements["KuranovSpinnerView"]
        guard spinner.waitForExistence(timeout: 0.5) else{
            return XCTFail("Expected spinner to exist")
        }
    }
    
    func testDayForecastSpinnerShouldAppearOnLoad(){
        let app = launchWeatherScreen()
        let view = app.otherElements["DayForecastView"]
        let spinner = view.activityIndicators.firstMatch
        guard spinner.waitForExistence(timeout: 0.5) else{
            return XCTFail("Expected spinner to exist")
        }
    }
    
    func testNetworkActivityIndicatorShouldAppearOnLoad(){
        let app = launchWeatherScreen()
        let statusBar = app.statusBars.firstMatch
        let indicator = statusBar.otherElements["Network connection in progress"]
        guard indicator.waitForExistence(timeout: 0.5) else{
            return XCTFail("Expected network indicator to exist")
        }
    }
    
    func waitForUnexistence(of element: XCUIElement, timeout: Double){
        let unexistance = NSPredicate(format: "exists == 0")
        let expect = expectation(for: unexistance, evaluatedWith: element)
        self.wait(for: [expect], timeout: timeout)
    }
    
    
    // MARK: On update
    
    func testKuranovSpinnerShouldAppearOnUpdate(){
        let app = launchWeatherScreen()
        let spinner = app.otherElements["KuranovSpinnerView"]
        waitForUnexistence(of: spinner, timeout: 5)
        scrollUp()
        spinner.waitForExistence(timeout: 5)
    }
    
    func testDayForecastSpinnerShouldAppearOnUpdate(){
        let app = launchWeatherScreen()
        let view = app.otherElements["DayForecastView"]
        let spinner = view.activityIndicators.firstMatch
        waitForUnexistence(of: spinner, timeout: 5)
        scrollUp()
        spinner.waitForExistence(timeout: 5)
    }
    
    func testNetworkActivityIndicatorShouldAppearOnUpdate(){
        let app = launchWeatherScreen()
        let statusBar = app.statusBars.firstMatch
        let indicator = statusBar.otherElements["Network connection in progress"]
        waitForUnexistence(of: indicator, timeout: 5)
        scrollUp()
        indicator.waitForExistence(timeout: 5)
    }
    
    func testActivityViewShouldAppearOnShareButtonTap(){
        let app = launchWeatherScreen()
        app.navigationBars.buttons["Share"].tap()
        let activityListView = app.otherElements["ActivityListView"]
        XCTAssertTrue(activityListView.exists)
    }
}
