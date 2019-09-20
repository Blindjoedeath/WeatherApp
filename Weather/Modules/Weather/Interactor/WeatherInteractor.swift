//
//  WeatherInteractor.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import RxSwift

protocol WeatherInteractorProtocol: class{
    
    var presenter: WeatherInteractorOutput! {get set}
    
    func configure()
    func refreshData()
    func getCity() -> String
}

protocol WeatherInteractorOutput: class{
    func noNetwork()
    func noLocation()
    func weatherRequestTimeOut()
    func found(weather: Weather)
    func found(weekForecast: [Weather])
    func setStyle(appStyle: AppStyle)
}

class WeatherInteractor{
    
    weak var presenter: WeatherInteractorOutput!
    
    let bag = DisposeBag()
    
    var cityRepository = CityRepository.instance
    var weatherRepository = WeatherRepository.instance
    var styleRepository = AppStyleRepository.instance
    
    var city: String {
        get{
            return cityRepository.city.value!
        }
    }
    
    deinit {
        print("Weather Interactor deinited")
    }
}

extension WeatherInteractor: WeatherInteractorProtocol{
    
    func createSubscriptions(){
        weatherRepository.weatherResult
            .subscribe(onNext: {[weak self] result in
                switch result{
                case .success(let weather):
                    self?.presenter.found(weather: weather)
                    break
                case .locationNotFound:
                    self?.presenter.noLocation()
                    break
                case .networkError:
                    self?.presenter.noNetwork()
                case .timeout:
                    self?.presenter.weatherRequestTimeOut()
                }
        }).disposed(by: bag)
        
        weatherRepository.forecastResult
            .subscribe(onNext: {[weak self] result in
                switch result{
                case .success(let forecast):
                    self?.presenter.found(weekForecast: forecast.weekAverage())
                    break
                case .locationNotFound:
                    self?.presenter.noLocation()
                    break
                case .networkError:
                    self?.presenter.noNetwork()
                case .timeout:
                    self?.presenter.weatherRequestTimeOut()
                }
        }).disposed(by: bag)
    }
    
    func configure() {
        styleRepository.appStyle
            .subscribe(
                onNext: {[weak self] style in
                    if let self = self{
                        self.presenter.setStyle(appStyle: style)
                    }
                })
            .disposed(by: bag)
        createSubscriptions()
        refreshData()
    }
    
    func getCity() -> String {
        return city
    }
    
    func refreshData() {
        weatherRepository.refreshWeather(for: city)
        weatherRepository.refreshForecast(for: city)
    }
}
