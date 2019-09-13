//
//  GeolocationServiceStub.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 11/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import RxSwift
@testable import Weather


public class GeolocationServiceStub: GeolocationServiceProtocol{
    
    var stubbedAccess: Observable<Bool>! = Observable.just(false)
    public var access: Observable<Bool> {
        return stubbedAccess
    }
    
    var stubbedAccessDetermined: Observable<Bool>! = Observable.just(false)
    public var accessDetermined: Observable<Bool> {
        return stubbedAccessDetermined
    }
    
    var stubbedGetLocalityResult: Observable<String?>! = Observable.just(nil)
    public func getLocality() -> Observable<String?> {
        return stubbedGetLocalityResult
    }
    
    public var timeLimit: Int = 10
}
