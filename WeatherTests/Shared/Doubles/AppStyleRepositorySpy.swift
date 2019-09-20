//
//  StyleRepositorySpy.swift
//  WeatherTests
//
//  Created by Oskar on 20/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import RxRelay
@testable import Weather


class AppStyleRepositorySpy: AppStyleRepositoryProtocol{
    var invokedAppStyleGetter = false
    var invokedAppStyleGetterCount = 0
    var stubbedAppStyle: BehaviorRelay<AppStyle>!
    var appStyle: BehaviorRelay<AppStyle> {
        invokedAppStyleGetter = true
        invokedAppStyleGetterCount += 1
        return stubbedAppStyle
    }
    var invokedAppStylesGetter = false
    var invokedAppStylesGetterCount = 0
    var stubbedAppStyles: [String: AppStyle]! = [:]
    var appStyles: [String: AppStyle] {
        invokedAppStylesGetter = true
        invokedAppStylesGetterCount += 1
        return stubbedAppStyles
    }
}
