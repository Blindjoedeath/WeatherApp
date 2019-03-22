//
//  LocationInteractor.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class LocationInteractor: LocationInteractorInput{
    
    var output: LocationInteractorOutput?
    lazy var geolocationService: GeolocationService = GeolocationService()
    
    func getLocation() {
        geolocationService.delegate = self
        geolocationService.getLocation()
    }
    
    func getWeather(for city: String){
        WeatherRequestStorage.clear()
        
        let weatherRequest = WeatherRequest<Weather>(url: ApiUrlService.weatherUrl(for: city))
        weatherRequest.perform{ result in
            switch result {
            case .result(let weather):
                self.output?.foundWeather()
            case .noNetwork:
                self.output?.noNetwork()
            case .noLocation:
                self.output?.noLocation()
            case .timeOut:
                self.output?.weatherRequestTimeOut()
            }
            WeatherRequestStorage.weather = result
        }
        
        let forecastRequest = WeatherRequest<Forecast>(url: ApiUrlService.forecastUrl(for: city))
        forecastRequest.perform{ result in
            WeatherRequestStorage.forecast = result
        }
    }
    
    var geolocationAccess: Bool {
        get{
            return geolocationService.access
        }     
    }
}

extension LocationInteractor: GeolocationServiceProtocol{
    
    func accessState(state: Bool) {
        output?.geolocationAccessChanged(state: state)
    }
    
    func timeOut() {
        output?.geolocationTimeOut()
    }
    
    func endWithError(error: NSError) {
        output?.geolocationError(error: error.domain)
    }
    
    func foundLocation(locality: String) {
        output?.foundLocality(locality: locality)
    }
}
