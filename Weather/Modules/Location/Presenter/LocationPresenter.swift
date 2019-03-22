//
//  LocationPresenter.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class LocationPresenter: LocationPresenterProtocol{
    
    var view: LocationViewProtocol!
    var router: LocationRouter!
    var interactor: LocationInteractorInput!

    func cityNameChanged(on city: String) {
        if city == ""{
            view?.isNextNavigationEnabled = false
        } else{
            view?.isNextNavigationEnabled = true
        }
    }
    
    func nextNavigationRequired(with city: String) {
        view.isDataLoadingIndicatorEnabled = true
        interactor.getWeather(for: city)
    }
    
    func geolocationRequired() {
        view.isDataLoadingIndicatorEnabled = true
        view.isNextNavigationEnabled = false
        interactor.getLocation()
    }
    
    func configureView() {       
        let date = Date()
        view.setToday(day: date.day)
        view.setCurrentDate(date: date.formatted(by: "d MMMM yyyy"))
        view.isNextNavigationEnabled = false
        view.isPermissionNotificationEnabled = !interactor.geolocationAccess
    }
}

extension LocationPresenter: LocationInteractorOutput{
    
    func geolocationAccessChanged(state: Bool) {
        if state{
            view.isPermissionNotificationEnabled = false
        } else{
            view.showAlert(title: "Опаньки..", message: "Проверьте локацию")
            view.isPermissionNotificationEnabled = true
            view.isDataLoadingIndicatorEnabled = false
        }
    }
    
    func geolocationTimeOut() {
        view.showAlert(title: "Опаньки..", message: "Время то не вечно..")
        view.isDataLoadingIndicatorEnabled = false
    }
    
    func geolocationError(error: String) {
        view.showAlert(title: "Опаньки..", message: error)
        view.isDataLoadingIndicatorEnabled = false
    }
    
    func foundLocality(locality: String) {
        view.setCity(city: locality)
        view.isDataLoadingIndicatorEnabled = false
        view.isNextNavigationEnabled = true
    }
    
    func weatherRequestTimeOut() {
        view.showAlert(title: "Опаньки..", message: "Время то не вечно..")
        view.isNextNavigationEnabled = false
        view.isDataLoadingIndicatorEnabled = false
    }
    
    func noNetwork() {
        view.showAlert(title: "Опаньки..", message: "Проверьте соеднинение")
        view.isNextNavigationEnabled = false
        view.isDataLoadingIndicatorEnabled = false
    }
    
    func noLocation() {
        view.showAlert(title: "Опаньки..", message: "Город не найден")
        view.isNextNavigationEnabled = false
        view.isDataLoadingIndicatorEnabled = false
    }
    
    func foundWeather() {
        view.isDataLoadingIndicatorEnabled = false
        router.presentWeatherInterface()
    }
    
    func prepareToRoute(with object: NSObject?) {
        view.isDataLoadingIndicatorEnabled = false
        router.prepare(with: object)
    }
}
