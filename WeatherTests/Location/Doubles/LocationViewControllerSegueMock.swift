//
//  LocationViewControllerSegueMock.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 11/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather

class LocationViewControllerSegueMock: LocationViewController{
    
    var performSegueTriggered = false
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        performSegueTriggered = true
    }
}
