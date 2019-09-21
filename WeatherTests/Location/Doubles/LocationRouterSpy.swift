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


class LocationRouterSpy: LocationRouterProtocol{
    
    
    var invokedPresenterSetter = false
    var invokedPresenterSetterCount = 0
    var invokedPresenter: LocationPresenterProtocol?
    var invokedPresenterList = [LocationPresenterProtocol?]()
    var invokedPresenterGetter = false
    var invokedPresenterGetterCount = 0
    var stubbedPresenter: LocationPresenterProtocol!
    var presenter: LocationPresenterProtocol! {
        set {
            invokedPresenterSetter = true
            invokedPresenterSetterCount += 1
            invokedPresenter = newValue
            invokedPresenterList.append(newValue)
        }
        get {
            invokedPresenterGetter = true
            invokedPresenterGetterCount += 1
            return stubbedPresenter
        }
    }
    
    
    var invokedRoute = false
    var invokedRouteCount = 0
    var invokedRouteParameters: (with: Any?, Void)?
    var invokedRouteParametersList = [(with: Any?, Void)]()
    var routeHandler: (() -> ())?
    func route(with: Any?) {
        invokedRoute = true
        invokedRouteCount += 1
        invokedRouteParameters = (with, ())
        invokedRouteParametersList.append((with, ()))
        routeHandler?()
    }
}
