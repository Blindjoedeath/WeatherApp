//
//  WeatherPresenterFake.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 18/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather

class WeatherInteractorOutputFake: WeatherInteractorOutput{
    func noNetwork() {
    }
    func noLocation() {
    }
    func weatherRequestTimeOut() {
    }
    func found(weather: Weather) {
    }
    func found(weekForecast: [Weather]) {
    }
    func found(dayForecast: [Weather]) {
    }
    func setStyle(appStyle: AppStyle) {
    }
}
