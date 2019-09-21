//
//  LocationInteractorFake.swift
//  WeatherTests
//
//  Created by Oskar on 13/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather

class LocationInteractorFake: LocationInteractorProtocol{
    var presenter: LocationInteractorOutput! {
        set {
        }
        get {
            return nil
        }
    }
    var isLocationAccessDetermined: Bool {
        return false
    }
    func load() {
    }
    func getLocation() {
    }
    func getWeather(for: String) {
    }
    func getCity() -> String? {
        return nil
    }
}
