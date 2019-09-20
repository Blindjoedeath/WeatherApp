//
//  DayForecastInteractorFake.swift
//  WeatherTests
//
//  Created by Oskar on 20/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather


class DayForecastInteractorFake: DayForecastInteractorProtocol{
    var presenter: DayForecastInteractorOutput! {
        set {
        }
        get {
            return nil
        }
    }
    func configure() {
    }
}
