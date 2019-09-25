//
//  WeatherUITests.swift
//  WeatherUITests
//
//  Created by Oskar on 25/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest

class LocationUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments.append("uiTests")
        app.launch() 
    }

    override func tearDown() {
    }

    func testNextButtonShouldAppearWhenCityWritten() {
        let app = XCUIApplication()
        let textField = app.textFields["CityTextField"]
        textField.tap()
        textField.typeText("Казань")
        let back = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        back.tap()
        let exists = app.buttons["NextButton"].exists
        XCTAssertTrue(exists)
    }
    
    func testNextButtonShouldDisappearWhenCityEmpty() {
        let app = XCUIApplication()
        let textField = app.textFields["CityTextField"]
        textField.tap()
        textField.typeText("Казань")
        let back = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        back.tap()
        
        textField.tap()
        textField.buttons["Clear text"].tap()
        
        back.tap()
        
        let exists = app.buttons["NextButton"].exists
        XCTAssertFalse(exists)
    }
    
    func testCitiesTableShouldAppearWhenLetterInput() {
        let app = XCUIApplication()
        let textField = app/*@START_MENU_TOKEN@*/.textFields["CityTextField"]/*[[".textFields[\"Введите город\"]",".textFields[\"CityTextField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        textField.tap()
        textField.typeText("К")
        let expect = expectation(description: "Cities list should appear")
        let citiesList = app.tables.firstMatch
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            XCTAssertTrue(citiesList.exists)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1){error in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
    
    func testCitiesTableShouldDisppearWhenDeselectTextField() {
        let app = XCUIApplication()
        let textField = app/*@START_MENU_TOKEN@*/.textFields["CityTextField"]/*[[".textFields[\"Введите город\"]",".textFields[\"CityTextField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        textField.tap()
        textField.typeText("К")
        
        let back = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        
        // dissmiss keyboard
        back.tap()
        // hides cities table view
        back.tap()
        
        let table = app.tables.firstMatch
        XCTAssertFalse(table.exists)
    }
    
    func testChosenCityInTableShouldAppearInTextField() {
        let app = XCUIApplication()
        let textField = app/*@START_MENU_TOKEN@*/.textFields["CityTextField"]/*[[".textFields[\"Введите город\"]",".textFields[\"CityTextField\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        textField.tap()
        textField.typeText("К")
        let cell = app.tables.cells.firstMatch
        let cellValue = cell.label
        cell.tap()
        
        let textFieldValue = textField.value as! String
        
        XCTAssertEqual(textFieldValue, cellValue)
    }
}
