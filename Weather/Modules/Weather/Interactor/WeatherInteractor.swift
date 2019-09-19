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
    func found(dayForecast: [Weather])
    func setStyle(appStyle: AppStyle)
}

class WeatherInteractor{
    
    weak var presenter: WeatherInteractorOutput!
    var subscripion: Disposable?
    var timeLimit = 10
    
    var weather: Observable<Weather>!
    var forecast: Observable<Forecast>!
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
    
    func createWeatherSubscription(){
        
        let anyWeather = weather.asObservable().map{ $0 as AnyObject }
        let anyForecast = forecast.asObservable().map{ $0 as AnyObject }
        
        subscripion = Observable.merge(anyWeather, anyForecast)
            .observeOn(MainScheduler.instance)
            .timeout(RxTimeInterval.seconds(timeLimit), scheduler: MainScheduler.instance)
            .subscribe(
                onNext: {[weak self] (anyObject) in
                    if let self = self{
                        if let weather = anyObject as? Weather{
                            self.presenter.found(weather: weather)
                        } else if let forecast = anyObject as? Forecast{
                            let weekForecast = forecast.weekAverage()
                            let dayForecast = forecast[0].map{$0}
                            self.presenter.found(weekForecast: weekForecast)
                            self.presenter.found(dayForecast: dayForecast)
                        }
                    }
                },
                onError: {[weak self] error in
                    if let self = self{
                        if let requestError = error as? ReactiveRequestError{
                            switch requestError{
                            case .badResponse:
                                self.presenter.noLocation()
                                break
                            case .noResponce:
                                self.presenter.noNetwork()
                                break
                            }
                        } else if let rxError = error as? RxError{
                            switch rxError{
                            case .timeout:
                                self.presenter.weatherRequestTimeOut()
                            default:
                                break
                            }
                        }
                    }
                })
        subscripion?.disposed(by: bag)
    }
    
    func configure() {
        weather = weatherRepository.lastWeather ?? weatherRepository.getWeather(for: city)
        forecast = weatherRepository.lastForecast ?? weatherRepository.getForecast(for: city)
        
        styleRepository.appStyle
            .subscribe(
                onNext: {[weak self] style in
                    if let self = self{
                        self.presenter.setStyle(appStyle: style)
                    }
                })
            .disposed(by: bag)
        
        createWeatherSubscription()
    }
    
    func getCity() -> String {
        return city
    }
    
    func refreshData() {
        subscripion?.dispose()
        
        weather = weatherRepository.getWeather(for: city)
        forecast = weatherRepository.getForecast(for: city)
        
        createWeatherSubscription()
    }
}
