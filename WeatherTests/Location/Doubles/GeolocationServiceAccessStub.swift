//
//  GeolocationServiceAccessStub.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 12/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
@testable import Weather

public class GeolocationServiceAccessStub: GeolocationService{
    
    
    private let accessStub = BehaviorRelay<Bool>(value: false)
    
    func setAccess(_ state: Bool){
        accessStub.accept(state)
    }
    
    override public var access: Observable<Bool> {
        get {
            return accessStub.asObservable()
        }
    }
    
}
