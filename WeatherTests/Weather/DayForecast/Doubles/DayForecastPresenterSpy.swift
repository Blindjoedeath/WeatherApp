//
//  DayForecastPresenterSpy.swift
//  WeatherTests
//
//  Created by Oskar on 20/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather

class DayForecastPresenterSpy: DayForecastPresenterProtocol{
    var invokedViewSetter = false
    var invokedViewSetterCount = 0
    var invokedView: DayForecastViewProtocol?
    var invokedViewList = [DayForecastViewProtocol?]()
    var invokedViewGetter = false
    var invokedViewGetterCount = 0
    var stubbedView: DayForecastViewProtocol!
    var view: DayForecastViewProtocol! {
        set {
            invokedViewSetter = true
            invokedViewSetterCount += 1
            invokedView = newValue
            invokedViewList.append(newValue)
        }
        get {
            invokedViewGetter = true
            invokedViewGetterCount += 1
            return stubbedView
        }
    }
    var invokedRouterSetter = false
    var invokedRouterSetterCount = 0
    var invokedRouter: DayForecastRouterProtocol?
    var invokedRouterList = [DayForecastRouterProtocol?]()
    var invokedRouterGetter = false
    var invokedRouterGetterCount = 0
    var stubbedRouter: DayForecastRouterProtocol!
    var router: DayForecastRouterProtocol! {
        set {
            invokedRouterSetter = true
            invokedRouterSetterCount += 1
            invokedRouter = newValue
            invokedRouterList.append(newValue)
        }
        get {
            invokedRouterGetter = true
            invokedRouterGetterCount += 1
            return stubbedRouter
        }
    }
    var invokedInteractorSetter = false
    var invokedInteractorSetterCount = 0
    var invokedInteractor: DayForecastInteractorProtocol?
    var invokedInteractorList = [DayForecastInteractorProtocol?]()
    var invokedInteractorGetter = false
    var invokedInteractorGetterCount = 0
    var stubbedInteractor: DayForecastInteractorProtocol!
    var interactor: DayForecastInteractorProtocol! {
        set {
            invokedInteractorSetter = true
            invokedInteractorSetterCount += 1
            invokedInteractor = newValue
            invokedInteractorList.append(newValue)
        }
        get {
            invokedInteractorGetter = true
            invokedInteractorGetterCount += 1
            return stubbedInteractor
        }
    }
    var invokedLoad = false
    var invokedLoadCount = 0
    func load() {
        invokedLoad = true
        invokedLoadCount += 1
    }
    var invokedUnload = false
    var invokedUnloadCount = 0
    func unload() {
        invokedUnload = true
        invokedUnloadCount += 1
    }
}
