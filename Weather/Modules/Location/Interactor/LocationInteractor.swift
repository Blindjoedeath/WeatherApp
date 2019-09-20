//
//  LocationInteractor.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import RxSwift

protocol LocationInteractorProtocol: class {
    
    var presenter: LocationInteractorOutput! {get set}
    
    func load()
    func getLocation()
    func getWeather(for: String)
    func getCity() -> String?
    var isLocationAccessDetermined: Bool {get}
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

class LocationInteractor: LocationInteractorProtocol{
    
    var isLocationAccessDetermined: Bool = false
    
    weak var presenter: LocationInteractorOutput!
    lazy var geolocationService: GeolocationServiceProtocol = GeolocationService()
    lazy var bag = DisposeBag()
    var weatherRepository = WeatherRepository.instance
    var cityRepository = CityRepository.instance
    var requestTimeout = 10
    
    func createSubscriptions(){
        
        let _ = geolocationService.access
            .subscribe(onNext: { state in
                self.presenter?.geolocationAccessDetermined(state: state)
            }).disposed(by: bag)
        
        let _ = geolocationService.accessDetermined
            .subscribe(onNext: {state in
                self.isLocationAccessDetermined = state
            }).disposed(by: bag)
    }
    
    func load(){
        createSubscriptions()
    }
    
    func getLocation() {
        let _ = geolocationService.getLocality()
            .subscribe(
                onNext: { locality in
                    if let locality = locality{
                        self.presenter.foundLocality(locality: locality)
                    } else {
                        self.presenter.geolocationError(error: "Couldn't get locality")
                    }
                },
                onError:{ error in
                    if let rxError = error as? RxError{
                        switch rxError{
                        case .timeout:
                            self.presenter.geolocationTimeOut()
                        default:
                            break
                        }
                    } else {
                        self.presenter.geolocationError(error: error.localizedDescription)
                    }
            }).disposed(by: bag)
    }
    
    func getWeather(for city: String){
        
        weatherRepository.weatherResult
            .subscribe(onNext: {[weak self]result in
                switch result{
                case .success:
                    self?.cityRepository.city.accept(city)
                    self?.presenter.foundWeather()
                    break
                case .locationNotFound:
                    self?.presenter.noLocation()
                    break
                case .networkError:
                    self?.presenter.noNetwork()
                case .timeout:
                    self?.presenter.weatherRequestTimeOut()
                default:
                    break
                }
            }).disposed(by: bag)
        
        weatherRepository.refreshWeather(for: city)
    }
    
    func setCity(_ city: String) {
        cityRepository.city.accept(city)
    }
    
    func getCity() -> String? {
        return cityRepository.city.value
    }
}
