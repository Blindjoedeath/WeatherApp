//
//  WeatherPresenter.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class WeatherPresenter: WeatherPresenterProtocol{
    
    weak var view: WeatherViewProtocol!
    var interactor: WeatherInteractorInput!
    var router: WeatherRouter!
    weak var delegate: WeatherPresenterDelegate?
    
    var city: String!
    
    var setWeather = false
    var setForecast = false
    
    func setIndicatorState(state: Bool){
        view.isUpdateIndicatorEnabled = state
        delegate?.isUpdatingIndicatorEnabled = state
    }
    
    func closeNavigationRequired() {
        interactor.close()
        delegate?.cancelAppearanceAnimation()
        setIndicatorState(state: false)
        router.close()
        view.close()
    }
    
    func shareNavigationRequired() {
        view.shareImage(with: "Приложение сделал Оскер")
    }
    
    func styleMenuNavigationRequired() {
        router.presentStyleMenu()
    }
    
    func updateDataRequired() {
        setIndicatorState(state: true)
        setWeather = false
        setForecast = false
        interactor.refreshData(for: city)
    }
    
    func configure(with city: String){
        self.city = city
    }
    
    func configureView() {
        let style = interactor.getStyle()
        view.setAppStyle(style: style)
        view.setTitle(title: city)
        
        router.presentDayForecast()
        setIndicatorState(state: true)
        interactor.configure()
        interactor.getAllWeather()
    }
    
    func prepareToRoute(with object: NSObject?){
        router.pepareStyleMenu(from: object)
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
    
    func found(weather: WeatherModel) {
        view.setCurrentWeather(weather: weather)
        setWeather = true
        view.isUpdateIndicatorEnabled = !(setWeather && setForecast)
    }
    
    func found(weekForecast: [WeatherModel]) {
        var items = weekForecast.map{
            return WeatherItem.from(model: $0, date: $0.date!.shortDayName)
        }
        items[0].date = "Сегодня"
        view.setWeekForecastData(forecast: items)
        setForecast = true
        view.isUpdateIndicatorEnabled = !(setWeather && setForecast)
    }
    
    func found(dayForecast: [WeatherModel]) {
        let items = dayForecast.map{
            return WeatherItem.from(model: $0, date: $0.date!.hour)
        }
        delegate?.updateWith(data: items)
        delegate?.animateDataAppearance()
        delegate?.isUpdatingIndicatorEnabled = false
    }
}

extension WeatherPresenter: StylePresenterDelegate{
    func styleChanged() {
        let style = interactor.getStyle()
        view.setAppStyle(style: style)
    }
}
