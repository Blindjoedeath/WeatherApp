//
//  StyleInteractorSpy.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 21/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather


class StyleInteractorSpy: StyleInteractorProtocol{
    var invokedPresenterSetter = false
    var invokedPresenterSetterCount = 0
    var invokedPresenter: StyleInteractorOutput?
    var invokedPresenterList = [StyleInteractorOutput?]()
    var invokedPresenterGetter = false
    var invokedPresenterGetterCount = 0
    var stubbedPresenter: StyleInteractorOutput!
    var presenter: StyleInteractorOutput! {
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
    var invokedSetStyle = false
    var invokedSetStyleCount = 0
    var invokedSetStyleParameters: (name: String, Void)?
    var invokedSetStyleParametersList = [(name: String, Void)]()
    func setStyle(name: String) {
        invokedSetStyle = true
        invokedSetStyleCount += 1
        invokedSetStyleParameters = (name, ())
        invokedSetStyleParametersList.append((name, ()))
    }
    var invokedGetAllStyles = false
    var invokedGetAllStylesCount = 0
    var stubbedGetAllStylesResult: [AppStyle]! = []
    func getAllStyles() -> [AppStyle] {
        invokedGetAllStyles = true
        invokedGetAllStylesCount += 1
        return stubbedGetAllStylesResult
    }
    var invokedConfigure = false
    var invokedConfigureCount = 0
    func configure() {
        invokedConfigure = true
        invokedConfigureCount += 1
    }
}
