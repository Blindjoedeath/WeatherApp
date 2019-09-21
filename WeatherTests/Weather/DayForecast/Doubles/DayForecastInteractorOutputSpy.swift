//
//  DayForecastInteractorOutputSpy.swift
//  WeatherTests
//
//  Created by Oskar on 20/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather

class DayForecastInteractorOutputSpy: DayForecastInteractorOutput{
    var invokedLoad = false
    var invokedLoadCount = 0
    var invokedLoadParameters: (dayForecast: [Weather], Void)?
    var invokedLoadParametersList = [(dayForecast: [Weather], Void)]()
    func load(dayForecast: [Weather]) {
        invokedLoad = true
        invokedLoadCount += 1
        invokedLoadParameters = (dayForecast, ())
        invokedLoadParametersList.append((dayForecast, ()))
    }
    var invokedDataWillLoad = false
    var invokedDataWillLoadCount = 0
    func dataWillLoad() {
        invokedDataWillLoad = true
        invokedDataWillLoadCount += 1
    }
}
