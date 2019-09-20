//
//  StyleViewControllerSpy.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 21/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather


class StyleViewControllerSpy: StyleViewProtocol{
    var invokedPresenterSetter = false
    var invokedPresenterSetterCount = 0
    var invokedPresenter: StylePresenterProtocol?
    var invokedPresenterList = [StylePresenterProtocol?]()
    var invokedPresenterGetter = false
    var invokedPresenterGetterCount = 0
    var stubbedPresenter: StylePresenterProtocol!
    var presenter: StylePresenterProtocol! {
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
    var invokedSetStyleParameters: (style: AppStyle, Void)?
    var invokedSetStyleParametersList = [(style: AppStyle, Void)]()
    func setStyle(style: AppStyle) {
        invokedSetStyle = true
        invokedSetStyleCount += 1
        invokedSetStyleParameters = (style, ())
        invokedSetStyleParametersList.append((style, ()))
    }
    var invokedSetItems = false
    var invokedSetItemsCount = 0
    var invokedSetItemsParameters: (items: [AppStyle], Void)?
    var invokedSetItemsParametersList = [(items: [AppStyle], Void)]()
    func setItems(items: [AppStyle]) {
        invokedSetItems = true
        invokedSetItemsCount += 1
        invokedSetItemsParameters = (items, ())
        invokedSetItemsParametersList.append((items, ()))
    }
}
