//
//  DayForecastInteractorySpy.swift
//  WeatherTests
//
//  Created by Oskar on 20/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather

class DayForecastInteractorySpy: DayForecastInteractorProtocol{
    var invokedPresenterSetter = false
    var invokedPresenterSetterCount = 0
    var invokedPresenter: DayForecastInteractorOutput?
    var invokedPresenterList = [DayForecastInteractorOutput?]()
    var invokedPresenterGetter = false
    var invokedPresenterGetterCount = 0
    var stubbedPresenter: DayForecastInteractorOutput!
    var presenter: DayForecastInteractorOutput! {
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
    var invokedConfigure = false
    var invokedConfigureCount = 0
    func configure() {
        invokedConfigure = true
        invokedConfigureCount += 1
    }
}
