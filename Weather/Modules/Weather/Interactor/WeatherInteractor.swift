//
//  WeatherInteractor.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import RxSwift

protocol WeatherInteractorInput: class{
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
    
    weak var output: WeatherInteractorOutput!
    var subscripion: Disposable!
    
    var weather: Observable<Weather>!
    var forecast: Observable<Forecast>!
    let bag = DisposeBag()
    
    let weatherRepository = WeatherRepository.instance
    let styleRepository = AppStyleRepository.instance
    
    var city: String {
        get{
            return CityRepository.instance.getCity()!
        }
    }
    
    func weekForecast(from forecast: Forecast) -> [Weather]{
        var result : [Weather] = []
        for i in 0..<forecast.daysCount{
            result.append(forecast[i, 2])
        }
        return result
    }
    
    deinit {
        print("Weather Interactor deinited")
    }
}

extension WeatherInteractor: WeatherInteractorInput{
    
    func createWeatherSubscription(){
        subscripion = Observable.combineLatest(weather, forecast)
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: {[weak self] (weather, forecast) in
                    if let self = self{
                        self.output.found(weather: weather)
                        
                        let weekModels = self.weekForecast(from: forecast)
                        let dayModels = forecast[0].map{$0}
                        self.output.found(weekForecast: weekModels)
                        self.output.found(dayForecast: dayModels)
                    }
                },
                onError: {[weak self] error in
                    if let self = self{
                        if let requestError = error as? ReactiveRequestError{
                            switch requestError{
                            case .badResponse:
                                self.output.noLocation()
                                break
                            case .noResponce:
                                self.output.noNetwork()
                                break
                            }
                        } else if let rxError = error as? RxError{
                            switch rxError{
                            case .timeout:
                                self.output.weatherRequestTimeOut()
                            default:
                                break
                            }
                        }
                    }
            })
        subscripion.disposed(by: bag)
    }
    
    func configure() {
        weather = weatherRepository.lastWeather ?? weatherRepository.getWeather(for: city)
        forecast = weatherRepository.lastForecast ?? weatherRepository.getForecast(for: city)
        
        styleRepository.appStyle
            .subscribe(
                onNext: {[weak self] style in
                    if let self = self{
                        self.output.setStyle(appStyle: style)
                    }
                })
            .disposed(by: bag)
        
        createWeatherSubscription()
    }
    
    func getCity() -> String {
        return city
    }
    
    func refreshData() {
        subscripion.dispose()
        
        weather = weatherRepository.getWeather(for: city)
        forecast = weatherRepository.getForecast(for: city)
        
        createWeatherSubscription()
    }
}
