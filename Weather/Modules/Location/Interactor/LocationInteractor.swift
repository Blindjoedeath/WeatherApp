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
    
    func getLocation()
    func getWeather(for: String)
    func setCity(_ city: String)
    func getCity() -> String?
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

class LocationInteractor: LocationInteractorProtocol{
    
    var locationAccessDetermined: Bool = false
    
    weak var presenter: LocationInteractorOutput!
    lazy var geolocationService = GeolocationService()
    lazy var bag = DisposeBag()
    var weatherRepository = WeatherRepository.instance
    var cityRepository = CityRepository.instance
    
    init() {
        let _ = geolocationService.access
            .subscribe(onNext: { state in
                self.locationAccessDetermined = true
                self.presenter?.geolocationAccessDetermined(state: state)
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
        
        let weather = weatherRepository.getWeather(for: city)
        weather
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: {[weak self] weather in
                    self?.presenter.foundWeather()
                },
                onError: {[weak self] error in
                    if let self = self{
                        if let requestError = error as? ReactiveRequestError{
                            switch requestError{
                            case .badResponse:
                                self.presenter?.noLocation()
                                break
                            case .noResponce:
                                self.presenter?.noNetwork()
                                break
                            }
                        } else if let rxError = error as? RxError{
                            switch rxError{
                            case .timeout:
                                self.presenter?.geolocationTimeOut()
                            default:
                                break
                            }
                        }
                    }
                }
            ).disposed(by: bag)
    }
    
    func setCity(_ city: String) {
        cityRepository.city.accept(city)
    }
    
    func getCity() -> String? {
        return cityRepository.city.value
    }
}
