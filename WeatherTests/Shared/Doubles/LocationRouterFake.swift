//
//  LocationRouterFake.swift
//  WeatherTests
//
//  Created by Oskar on 13/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather


class LocationRouterFake: LocationRouterProtocol{
    
    var presenter: LocationPresenterProtocol! {
        set {
        }
        get {
            return nil
        }
    }
    
    func route(with: Any?) {
    }
}
