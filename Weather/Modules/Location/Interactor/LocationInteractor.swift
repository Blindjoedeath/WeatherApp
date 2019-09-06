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
    func set(city: String)
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
    var weatherRepository = WeatherRepository.instance
    var cityRepository = CityRepository.instance
    
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
        
        let weather = weatherRepository.getWeather(for: city)
        weather
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: {weather in
                    self.output?.foundWeather()
                },
                onError: {error in
                    if let requestError = error as? ReactiveRequestError{
                        switch requestError{
                        case .badResponse:
                            self.output?.noLocation()
                            break
                        case .noResponce:
                            self.output?.noNetwork()
                            break
                        }
                    } else if let rxError = error as? RxError{
                        switch rxError{
                        case .timeout:
                            self.output?.geolocationTimeOut()
                        default:
                            break
                        }
                    }
                },
                onDisposed: {
                    print("disposed weather")
                }
            ).disposed(by: bag)
    }
    
    func set(city: String) {
        cityRepository.set(city: city)
    }
}
