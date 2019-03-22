//
//  LocationInteractorInput.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol LocationInteractorInput: class {
    func getLocation()
    func getWeather(for: String)
    var geolocationAccess: Bool {get }
}

protocol LocationInteractorOutput: class {
    func noNetwork()
    func noLocation()
    func weatherRequestTimeOut()
    func foundWeather()
    
    func geolocationAccessChanged(state: Bool)
    func geolocationTimeOut()
    func geolocationError(error: String)
    func foundLocality(locality: String)
}
