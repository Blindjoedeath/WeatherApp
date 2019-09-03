//
//  LocationInteractor.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import RxSwift

protocol LocationInteractorInput: class {
    func getLocation()
    func getWeather(for: String)
    var locationAccessDetermined: Bool {get}
}

protocol LocationInteractorOutput: class {
    func noNetwork()
    func noLocation()
    func weatherRequestTimeOut()
    func foundWeather()
    
    func geolocationAccessDetermined(state: Bool)
    func geolocationTimeOut()
    func geolocationError(error: String)
    func foundLocality(locality: String)
}

class LocationInteractor: LocationInteractorInput{
    
    var locationAccessDetermined: Bool = false
    
    var output: LocationInteractorOutput?
    lazy var geolocationService = GeolocationService()
    lazy var bag = DisposeBag()
    
    init() {
        let _ = geolocationService.access
            .subscribe(onNext: { state in
                self.locationAccessDetermined = true
                self.output?.geolocationAccessDetermined(state: state)
            }).disposed(by: bag)
        
        let _ = geolocationService.accessDetermined
            .subscribe(onNext: {state in
                self.locationAccessDetermined = state
            }).disposed(by: bag)
    }
    
    func getLocation() {
        let _ = geolocationService.getLocality()
            .subscribe(
                onNext: { locality in
                    if let locality = locality{
                        self.output?.foundLocality(locality: locality)
                    } else {
                        self.output?.geolocationError(error: "Couldn't get locality")
                    }
                },
                onError:{ error in
                    if let rxError = error as? RxError{
                        switch rxError{
                        case .timeout:
                            self.output?.geolocationTimeOut()
                        default:
                            break
                        }
                    } else {
                        self.output?.geolocationError(error: error.localizedDescription)
                    }
            }).disposed(by: bag)
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
}
