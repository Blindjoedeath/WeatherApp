//
//  LocationViewControllerFake.swift
//  WeatherTests
//
//  Created by Oskar on 12/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather

class LocationViewFake: LocationViewProtocol{
    
    var presenter: LocationPresenterProtocol! {
        set {
        }
        get {
            return nil
        }
    }
    var isNextNavigationEnabled: Bool {
        set {
        }
        get {
            return false
        }
    }
    var isPermissionNotificationEnabled: Bool {
        set {
        }
        get {
            return false
        }
    }
    var isLocalityButtonEnabled: Bool {
        set {
        }
        get {
            return false
        }
    }
    var isDataLoadingIndicatorEnabled: Bool {
        set {
        }
        get {
            return false
        }
    }
    func showAlert(title: String, message: String) {
    }
    func setDate(_: String) {
    }
    func setDay(_: String) {
    }
    func setCity(_: String) {
    }
    func setCities(_: [String]) {
    }
}
