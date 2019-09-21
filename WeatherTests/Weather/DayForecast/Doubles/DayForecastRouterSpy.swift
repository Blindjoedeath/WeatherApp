//
//  DayForecastRouterSpy.swift
//  WeatherTests
//
//  Created by Oskar on 20/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather

class DayForecastRouterSpy: DayForecastRouterProtocol{
    var invokedPresenterSetter = false
    var invokedPresenterSetterCount = 0
    var invokedPresenter: DayForecastPresenterProtocol?
    var invokedPresenterList = [DayForecastPresenterProtocol?]()
    var invokedPresenterGetter = false
    var invokedPresenterGetterCount = 0
    var stubbedPresenter: DayForecastPresenterProtocol!
    var presenter: DayForecastPresenterProtocol! {
        set {
            invokedPresenterSetter = true
            invokedPresenterSetterCount += 1
            invokedPresenter = newValue
            invokedPresenterList.append(newValue)
        }
        get {
            invokedPresenterGetter = true
            invokedPresenterGetterCount += 1
            return stubbedPresenter
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
