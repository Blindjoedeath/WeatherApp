//
//  DayForecastViewSpy.swift
//  WeatherTests
//
//  Created by Oskar on 20/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather

class DayForecastViewSpy: DayForecastViewProtocol{
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
    var invokedIsUpdatingIndicatorEnabledSetter = false
    var invokedIsUpdatingIndicatorEnabledSetterCount = 0
    var invokedIsUpdatingIndicatorEnabled: Bool?
    var invokedIsUpdatingIndicatorEnabledList = [Bool]()
    var invokedIsUpdatingIndicatorEnabledGetter = false
    var invokedIsUpdatingIndicatorEnabledGetterCount = 0
    var stubbedIsUpdatingIndicatorEnabled: Bool! = false
    var isUpdatingIndicatorEnabled: Bool {
        set {
            invokedIsUpdatingIndicatorEnabledSetter = true
            invokedIsUpdatingIndicatorEnabledSetterCount += 1
            invokedIsUpdatingIndicatorEnabled = newValue
            invokedIsUpdatingIndicatorEnabledList.append(newValue)
        }
        get {
            invokedIsUpdatingIndicatorEnabledGetter = true
            invokedIsUpdatingIndicatorEnabledGetterCount += 1
            return stubbedIsUpdatingIndicatorEnabled
        }
    }
    var invokedCancelAnimation = false
    var invokedCancelAnimationCount = 0
    func cancelAnimation() {
        invokedCancelAnimation = true
        invokedCancelAnimationCount += 1
    }
    var invokedLoad = false
    var invokedLoadCount = 0
    var invokedLoadParameters: (dayForecast: [WeatherItem], Void)?
    var invokedLoadParametersList = [(dayForecast: [WeatherItem], Void)]()
    func load(dayForecast: [WeatherItem]) {
        invokedLoad = true
        invokedLoadCount += 1
        invokedLoadParameters = (dayForecast, ())
        invokedLoadParametersList.append((dayForecast, ()))
    }
}
