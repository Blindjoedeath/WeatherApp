//
//  DayForecastPresenter.swift
//  Weather
//
//  Created by Blind Joe Death on 22/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol DayForecastPresenterProtocol: class {
    var view: DayForecastViewProtocol! {get set}
    var router: DayForecastRouterProtocol! {get set}
    var interactor: DayForecastInteractorProtocol! {get set}
    
    func load()
    func unload()
}

class DayForecastPresenter: DayForecastPresenterProtocol{
    
    weak var view: DayForecastViewProtocol!
    var interactor: DayForecastInteractorProtocol!
    var router: DayForecastRouterProtocol!
    
    func load() {
        interactor.configure()
        view.isUpdatingIndicatorEnabled = true
    }
    
    func unload() {
        view.cancelAnimation()
    }
}


extension DayForecastPresenter: DayForecastInteractorOutput{
    func load(dayForecast: [Weather]) {
        let items = dayForecast.map{ WeatherItem.from(weather: $0, date: $0.date!.hour)}
        view.isUpdatingIndicatorEnabled = false
        view.load(dayForecast: items)
    }
    
    func dataWillLoad() {
        view.isUpdatingIndicatorEnabled = true
    }
}
