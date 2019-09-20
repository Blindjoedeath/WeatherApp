//
//  WeatherRepository.swift
//  Weather
//
//  Created by Oskar on 06/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

public enum WeatherResult<T>{
    case networkError
    case locationNotFound
    case timeout
    case success(T)
}

protocol WeatherRepositoryProtocol{
    
    var weatherResult: Observable<WeatherResult<Weather>> {get}
    var forecastResult: Observable<WeatherResult<Forecast>> {get}
    
    var requestTimeout: Int {get set}
    
    func refreshWeather(for city: String)
    func refreshForecast(for city: String)
}

class WeatherRepository: WeatherRepositoryProtocol{
    
    static let instance: WeatherRepositoryProtocol = WeatherRepository()
    
    private var weatherSubject = PublishSubject<WeatherResult<Weather>>()
    private var forecastSubject = PublishSubject<WeatherResult<Forecast>>()
    
    var weatherResult: Observable<WeatherResult<Weather>>{
        return weatherSubject.asObservable()
    }
    var forecastResult: Observable<WeatherResult<Forecast>>{
        return forecastSubject.asObservable()
    }
    
    var requestTimeout: Int = 10
    
    var bag = DisposeBag()
    
    private init(){
        
    }
    
    private func emit<T>(observable: Observable<T>, in subject: PublishSubject<WeatherResult<T>>){
        observable
            .observeOn(MainScheduler.instance)
            .timeout(RxTimeInterval.seconds(requestTimeout), scheduler: MainScheduler.instance)
            .subscribe(
                onNext: {object in
                    subject.onNext(.success(object))
                },
                onError: {error in
                        if let requestError = error as? ReactiveRequestError{
                            switch requestError{
                            case .badResponse:
                                subject.onNext(.locationNotFound)
                                break
                            case .noResponce:
                                subject.onNext(.networkError)
                                break
                            }
                        } else if let rxError = error as? RxError{
                            switch rxError{
                            case .timeout:
                                subject.onNext(.timeout)
                                break
                            default:
                                break
                            }
                        }
                    }
            ).disposed(by: bag)
    }
    
    func refreshWeather(for city: String){
        let url = weatherUrl(for: city)
        let observable = ReactiveRequest<Weather>.create(for: url).share()
        emit(observable: observable, in: weatherSubject)
    }
    
    func refreshForecast(for city: String){
        let url = forecastUrl(for: city)
        let observable = ReactiveRequest<Forecast>.create(for: url).share()
        emit(observable: observable, in: forecastSubject)
    }
    
    private func weatherUrl(for city: String) -> URL{
        let urlString = String(format:
            "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@", city, weatherApiToken)
        return createUrl(for: urlString)
    }
    
    private func forecastUrl(for city: String) -> URL{
        let urlString = String(format:
            "https://samples.openweathermap.org/data/2.5/forecast?q=%@&appid=%@", city, weatherApiToken)
        return createUrl(for: urlString)
    }
    
    private func createUrl(for urlString: String) -> URL{
        let formatted = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return URL(string: formatted)!
    }
}
