//
//  LocationPresenterFake.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 19/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather

class LocationPresenterFake: LocationPresenterProtocol{
    var view: LocationViewProtocol! {
        set {
        }
        get {
            return nil
        }
    }
    var interactor: LocationInteractorProtocol! {
        set {
        }
        get {
            return nil
        }
    }
    var router: LocationRouterProtocol! {
        set {
        }
        get {
            return nil
        }
    }
    func cityNameChanged(on: String) {
    }
    func nextNavigationRequired() {
    }
    func geolocationRequired() {
    }
    func load() {
    }
}
