//
//  GeolocationServiceLocalityStub.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 12/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import RxSwift
@testable import Weather

public class GeolocationServiceLocalityStub: GeolocationService{
    
    var localityToSend: String!
    
    override public func getLocality() -> Observable<String?> {
        
        return Observable<String?>.just(localityToSend)
    }
}



