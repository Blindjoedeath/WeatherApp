//
//  LocationPresenterSpy.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 11/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather

class LocationInteractorOutputSpy: LocationInteractorOutput{
    
    var invokedNoNetwork = false
    var invokedNoNetworkCount = 0
    func noNetwork() {
        invokedNoNetwork = true
        invokedNoNetworkCount += 1
    }
    
    
    var invokedNoLocation = false
    var invokedNoLocationCount = 0
    func noLocation() {
        invokedNoLocation = true
        invokedNoLocationCount += 1
    }
    
    
    var invokedWeatherRequestTimeOut = false
    var invokedWeatherRequestTimeOutCount = 0
    var weatherRequestTimeOutHandler: (() -> ())?
    func weatherRequestTimeOut() {
        invokedWeatherRequestTimeOut = true
        invokedWeatherRequestTimeOutCount += 1
        weatherRequestTimeOutHandler?()
    }
    
    
    var invokedFoundWeather = false
    var invokedFoundWeatherCount = 0
    func foundWeather() {
        print("found")
        invokedFoundWeather = true
        invokedFoundWeatherCount += 1
    }
    
    
    var invokedGeolocationAccessDetermined = false
    var invokedGeolocationAccessDeterminedCount = 0
    var invokedGeolocationAccessDeterminedParameters: (state: Bool, Void)?
    var invokedGeolocationAccessDeterminedParametersList = [(state: Bool, Void)]()
    func geolocationAccessDetermined(state: Bool) {
        invokedGeolocationAccessDetermined = true
        invokedGeolocationAccessDeterminedCount += 1
        invokedGeolocationAccessDeterminedParameters = (state, ())
        invokedGeolocationAccessDeterminedParametersList.append((state, ()))
    }
    
    
    var invokedGeolocationTimeOut = false
    var invokedGeolocationTimeOutCount = 0
    var geolocationTimeOutHandler: (() -> ())?
    func geolocationTimeOut() {
        invokedGeolocationTimeOut = true
        invokedGeolocationTimeOutCount += 1
        geolocationTimeOutHandler?()
    }
    
    
    var invokedGeolocationError = false
    var invokedGeolocationErrorCount = 0
    var invokedGeolocationErrorParameters: (error: String, Void)?
    var invokedGeolocationErrorParametersList = [(error: String, Void)]()
    func geolocationError(error: String) {
        invokedGeolocationError = true
        invokedGeolocationErrorCount += 1
        invokedGeolocationErrorParameters = (error, ())
        invokedGeolocationErrorParametersList.append((error, ()))
    }
    
    
    var invokedFoundLocality = false
    var invokedFoundLocalityCount = 0
    var invokedFoundLocalityParameters: (locality: String, Void)?
    var invokedFoundLocalityParametersList = [(locality: String, Void)]()
    func foundLocality(locality: String) {
        invokedFoundLocality = true
        invokedFoundLocalityCount += 1
        invokedFoundLocalityParameters = (locality, ())
        invokedFoundLocalityParametersList.append((locality, ()))
    }
}
