//
//  WeatherPresenter.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol WeatherPresenterProtocol: class{
    
    var interactor: WeatherInteractorProtocol! {get set}
    var view: WeatherViewProtocol! {get set}
    var router: WeatherRouterProtocol! {get set}
    
    func closeNavigationRequired()
    func shareNavigationRequired()
    func styleMenuNavigationRequired()
    func updateDataRequired()
    func configureView()
}

class WeatherPresenter: WeatherPresenterProtocol{
    
    weak var view: WeatherViewProtocol!
    var interactor: WeatherInteractorProtocol!
    var router: WeatherRouterProtocol!
    
    var setWeather = false
    var setForecast = false
    
    func setIndicatorState(state: Bool){
        view.isUpdateIndicatorEnabled = state
    }
    
    func closeNavigationRequired() {
        setIndicatorState(state: false)
        router.unload()
        view.close()
    }
    
    func shareNavigationRequired() {
        view.shareImage(with: "Приложение сделал Оскер")
    }
    
    func styleMenuNavigationRequired() {
        router.route()
    }
    
    func updateDataRequired() {
        setIndicatorState(state: true)
        setWeather = false
        setForecast = false
        interactor.refreshData()
    }
    
    func configureView() {
        view.setTitle(title: interactor.getCity())
        
        router.presentDayForecast()
        setIndicatorState(state: true)
        interactor.configure()
    }
    
    deinit {
        print("Weather Presenter deinited")
    }
}

extension WeatherPresenter: WeatherInteractorOutput{
    func noNetwork() {
        view.showAlert(title: "Опаньки..", message: "Проверьте соеднинение")
        setIndicatorState(state: false)
    }
    
    func noLocation() {
        view.showAlert(title: "Опаньки..", message: "Город не найден")
        setIndicatorState(state: false)
    }
    
    func weatherRequestTimeOut() {
        view.showAlert(title: "Опаньки..", message: "Время вышло")
        setIndicatorState(state: false)
    }
    
    func found(weather: Weather) {
        let weather = WeatherItem.from(weather: weather, date: "Сегодня")
        view.setCurrentWeather(weather: weather)
        setWeather = true
        view.isUpdateIndicatorEnabled = !(setWeather && setForecast)
    }
    
    func found(weekForecast: [Weather]) {
        var items = weekForecast.map{
            return WeatherItem.from(weather: $0, date: $0.date!.shortDayName)
        }
        items[0].date = "Сегодня"
        view.setWeekForecastData(forecast: items)
        setForecast = true
        view.isUpdateIndicatorEnabled = !(setWeather && setForecast)
    }
    /*
    func found(dayForecast: [Weather]) {
        let items = dayForecast.map{
            return WeatherItem.from(weather: $0, date: $0.date!.hour)
        }
        delegate?.updateWith(data: items)
        delegate?.animateDataAppearance()
        delegate?.isUpdatingIndicatorEnabled = false
    }
 */
    
    func setStyle(appStyle: AppStyle) {
        view.setAppStyle(style: appStyle)
    }
}
