//
//  StyleInteractorOutputSpy.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 21/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather

class StyleInteractorOutputSpy: StyleInteractorOutput{
    var invokedStyleChanged = false
    var invokedStyleChangedCount = 0
    var invokedStyleChangedParameters: (appStyle: AppStyle, Void)?
    var invokedStyleChangedParametersList = [(appStyle: AppStyle, Void)]()
    func styleChanged(appStyle: AppStyle) {
        invokedStyleChanged = true
        invokedStyleChangedCount += 1
        invokedStyleChangedParameters = (appStyle, ())
        invokedStyleChangedParametersList.append((appStyle, ()))
    }
}
