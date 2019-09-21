//
//  LocationPresenterTests.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 11/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import XCTest
@testable import Weather

class LocationPresenterTests: XCTestCase {

    var configurator: LocationConfigurator!
    
    override func setUp() {
        configurator = LocationConfigurator()
    }

    override func tearDown() {
        configurator = nil
    }
    
    
    // MARK: Presenter to Router Tests
    
    func buildPresenterToRouter() -> (LocationPresenter, LocationRouterSpy){
        let interactor = LocationInteractorSpy()
        configurator.interactor = interactor
        configurator.view = LocationViewFake()
        configurator.router = LocationRouterSpy()
        let router = configurator.build() as! LocationRouterSpy
        let presenter = configurator.presenter! as! LocationPresenter
        
        return (presenter, router)
    }
    
    func testPresenterShouldRouteAsyncWhenLoadsIfCityIsAlreadySet(){
        let (presenter, router) = buildPresenterToRouter()
        let interactor = configurator.interactor as! LocationInteractorSpy
        
        interactor.stubbedGetCityResult = "Previously saved city"
        presenter.load()
        
        let expect = expectation(description: "Route should be called")
        
        router.routeHandler = {
            XCTAssertTrue(router.invokedRoute)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testPresenterShouldRouteWhenFoundWeather(){
        let (presenter, router) = buildPresenterToRouter()
        
        presenter.foundWeather()
        
        XCTAssertTrue(router.invokedRoute)
    }
    
    
    // MARK: Presenter to Interactor Tests
    
    func buildPresenterToInteractor() -> (LocationPresenter, LocationInteractorSpy){
        let interactor = LocationInteractorSpy()
        configurator.interactor = interactor
        configurator.view = LocationViewFake()
        let presenter = configurator.build().presenter! as! LocationPresenter
        
        return (presenter, interactor)
    }
    
    func testPresenterShouldRequestWeatherWhenNextNavigationRequired(){
        let (presenter, interactor) = buildPresenterToInteractor()
        
        presenter.cityNameChanged(on: "Bangladesh")
        presenter.nextNavigationRequired()
        
        XCTAssertTrue(interactor.invokedGetWeather)
    }
    
    func testPresenterShouldRequestGeolocationWhenGeolocationRequired(){
        let (presenter, interactor) = buildPresenterToInteractor()
        
        presenter.geolocationRequired()
        
        XCTAssertTrue(interactor.invokedGetLocation)
    }
    
    
        // MARK: Presenter to View Tests
    
    func buildPresenterToView() -> (LocationPresenter, LocationViewSpy){
        let view = LocationViewSpy()
        configurator.interactor = LocationInteractorSpy()
        configurator.view = view
        configurator.router = LocationRouterSpy()
        let _ = configurator.build()
        let presenter = configurator.presenter as! LocationPresenter
        
        return (presenter, view)
    }
    
    func testPresenterShouldChangeViewWhenLoad(){
        let (presenter, view) = buildPresenterToView()
        let interactor = presenter.interactor as! LocationInteractorSpy
        let repository = CitiesBaseRespositoryStub()
        let stubbedCities = ["Chabib", "Nurmagomedov"]
        
        repository.stubbedCities = stubbedCities
        presenter.repository = repository
        interactor.stubbedIsLocationAccessDetermined = false
        presenter.load()
        
        let date = Date()
        let invokedDay = view.invokedSetDayParameters?.day
        let invokedDate = view.invokedSetDateParameters?.date
        let invokedCities = view.invokedSetCitiesParameters?.cities
        let localityButtonEnabled = view.invokedIsLocalityButtonEnabled!
        let permissionEnabled = view.invokedIsPermissionNotificationEnabled!
        
        XCTAssertEqual(date.day, invokedDay)
        XCTAssertEqual(date.formatted(by: "d MMMM yyyy"), invokedDate)
        XCTAssertEqual(stubbedCities, invokedCities)
        XCTAssertTrue(localityButtonEnabled)
        XCTAssertTrue(permissionEnabled)
    }
    
    func testPresenterShouldDisableNextNavigationWhenCityIsEmpty(){
        let (presenter, view) = buildPresenterToView()
        presenter.cityNameChanged(on: "")
        let assignedValue = view.invokedIsNextNavigationEnabled!
        XCTAssertFalse(assignedValue)
    }
    
    func testPresenterShouldChangeNextNavigationWhenCityChanges(){
        let (presenter, view) = buildPresenterToView()

        presenter.cityNameChanged(on: "value")
        var navigationEnabled = view.invokedIsNextNavigationEnabled!
        XCTAssertTrue(navigationEnabled)
        
        presenter.cityNameChanged(on: "")
        navigationEnabled = view.invokedIsNextNavigationEnabled!
        XCTAssertFalse(navigationEnabled)
    }
    
    func testPresenterShouldChangeViewWhenNextNavigationRequired(){
        let (presenter, view) = buildPresenterToView()
        presenter.nextNavigationRequired()
        let assignedValue = view.invokedIsDataLoadingIndicatorEnabled!
        XCTAssertTrue(assignedValue)
    }
    
    func testPresenterShouldChangeViewWhenGeolocationRequired(){
        let (presenter, view) = buildPresenterToView()
        presenter.geolocationRequired()
        let indicatorEnabled = view.invokedIsDataLoadingIndicatorEnabled!
        let nextNavigationEnabled = view.invokedIsNextNavigationEnabled!
        XCTAssertTrue(indicatorEnabled)
        XCTAssertFalse(nextNavigationEnabled)
    }
    
    func testPresenterShouldChangeViewWhenGeolocationAccessDetermined(){
        let (presenter, view) = buildPresenterToView()
        
        presenter.geolocationAccessDetermined(state: false)
        let indicatorEnabled = view.invokedIsDataLoadingIndicatorEnabled!
        var permissionEnabled = view.invokedIsPermissionNotificationEnabled!
        var localityButtonEnabled = view.invokedIsLocalityButtonEnabled!
        XCTAssertFalse(indicatorEnabled)
        XCTAssertTrue(permissionEnabled)
        XCTAssertFalse(localityButtonEnabled)
        
        presenter.geolocationAccessDetermined(state: true)
        permissionEnabled = view.invokedIsPermissionNotificationEnabled!
        localityButtonEnabled = view.invokedIsLocalityButtonEnabled!
        XCTAssertFalse(permissionEnabled)
        XCTAssertTrue(localityButtonEnabled)
    }
    
    func testPresenterShouldChangeViewWhenGeolocationTimeOut(){
        let (presenter, view) = buildPresenterToView()
        presenter.geolocationTimeOut()
        let indicatorEnabled = view.invokedIsDataLoadingIndicatorEnabled!
        let (title, message) = view.invokedShowAlertParameters!
        XCTAssertFalse(indicatorEnabled)
        XCTAssertEqual(title, "Exception")
        XCTAssertEqual(message, "Timeout")
    }
    
    func testPresenterShouldChangeViewWhenGeolocationError(){
        let (presenter, view) = buildPresenterToView()
        let errorMessage = "Color of mude is blue"
        presenter.geolocationError(error: errorMessage)
        let indicatorEnabled = view.invokedIsDataLoadingIndicatorEnabled!
        let (title, message) = view.invokedShowAlertParameters!
        
        XCTAssertFalse(indicatorEnabled)
        XCTAssertEqual(title, "Exception")
        XCTAssertEqual(message, errorMessage)
    }
    
    func testPresenterShouldChangeViewWhenFoundLocality(){
        let (presenter, view) = buildPresenterToView()
        let locality = "ExtraBaw"
        presenter.foundLocality(locality: locality)
        
        let receivedCity = view.invokedSetCityParameters?.city
        let indicatorEnabled = view.invokedIsDataLoadingIndicatorEnabled!
        let nextNavigationEnabled = view.invokedIsNextNavigationEnabled!
        
        XCTAssertEqual(locality, receivedCity)
        XCTAssertFalse(indicatorEnabled)
        XCTAssertTrue(nextNavigationEnabled)
        
    }
    
    func testPresenterShouldChangeViewWhenWeatherRequestTimeout(){
        let (presenter, view) = buildPresenterToView()
        presenter.weatherRequestTimeOut()
        let indicatorEnabled = view.invokedIsDataLoadingIndicatorEnabled!
        let (title, message) = view.invokedShowAlertParameters!
        XCTAssertFalse(indicatorEnabled)
        XCTAssertEqual(title, "Exception")
        XCTAssertEqual(message, "Timeout")
    }
    
    func testPresenterShouldChangeViewWhenNoNetwork(){
        let (presenter, view) = buildPresenterToView()
        presenter.noNetwork()
        let indicatorEnabled = view.invokedIsDataLoadingIndicatorEnabled!
        let (title, message) = view.invokedShowAlertParameters!
        XCTAssertFalse(indicatorEnabled)
        XCTAssertEqual(title, "Exception")
        XCTAssertEqual(message, "No network")
    }
    
    func testPresenterShouldChangeViewWhenNoLocation(){
        let (presenter, view) = buildPresenterToView()
        presenter.noLocation()
        let indicatorEnabled = view.invokedIsDataLoadingIndicatorEnabled!
        let (title, message) = view.invokedShowAlertParameters!
        XCTAssertFalse(indicatorEnabled)
        XCTAssertEqual(title, "Exception")
        XCTAssertEqual(message, "No location")
    }
    
    func testPresenterShouldChangeViewWhenFoundWeather(){
        let (presenter, view) = buildPresenterToView()
        presenter.noNetwork()
        let indicatorEnabled = view.invokedIsDataLoadingIndicatorEnabled!
        XCTAssertFalse(indicatorEnabled)
    }
}
