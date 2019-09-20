//
//  DayForecastInteractor.swift
//  Weather
//
//  Created by Oskar on 20/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import RxSwift

protocol DayForecastInteractorProtocol: class{
    var presenter: DayForecastInteractorOutput! {get set}
    
    func configure()
}

protocol DayForecastInteractorOutput: class{
    func load(dayForecast: [Weather])
    func dataWillLoad()
}

class DayForecastInteractor: DayForecastInteractorProtocol{
    weak var presenter: DayForecastInteractorOutput!
    
    var weatherRepository = WeatherRepository.instance
    var bag = DisposeBag()
    
    func configure() {
        weatherRepository.forecastResult
            .subscribe(onNext: {[weak self] result in
                switch result{
                case .success(let forecast):
                    self?.presenter.load(dayForecast: forecast[0])
                    break
                case .loading:
                    self?.presenter.dataWillLoad()
                default:
                    break
                }
            }).disposed(by: bag)
    }
}
