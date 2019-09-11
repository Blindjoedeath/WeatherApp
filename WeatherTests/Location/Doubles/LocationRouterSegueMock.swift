//
//  LocationRouterSegueMock.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 11/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import UIKit
@testable import Weather


class LocationRouterSegueMock: LocationRouter{
    var receivedSegue: UIStoryboardSegue!
    
    var nextModuleFromSegueHandler: (() -> ())?
    
    override func nextModuleFrom(segue: UIStoryboardSegue, with data: Any?) {
        receivedSegue = segue
        nextModuleFromSegueHandler?()
    }
}
