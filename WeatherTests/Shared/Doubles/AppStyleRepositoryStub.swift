//
//  AppStyleRepositoryStub.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 19/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import RxRelay
@testable import Weather

class AppStyleRepositoryStub: AppStyleRepositoryProtocol{
    var stubbedAppStyle: BehaviorRelay<AppStyle>!
    
    var appStyle: BehaviorRelay<AppStyle> {
        return stubbedAppStyle
    }
}
