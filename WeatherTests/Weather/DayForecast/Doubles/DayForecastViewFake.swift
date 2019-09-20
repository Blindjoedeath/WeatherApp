//
//  DayForecastViewFake.swift
//  WeatherTests
//
//  Created by Oskar on 20/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather

class DayForecastViewFake: DayForecastViewProtocol{
    var presenter: DayForecastPresenterProtocol! {
        set {
        }
        get {
            return nil
        }
    }
    
    var isUpdatingIndicatorEnabled: Bool {
        set {
        }
        get {
            return false
        }
    }
    
    func cancelAnimation() {
    }
    
    func load(dayForecast: [WeatherItem]) {
    }
    
}
