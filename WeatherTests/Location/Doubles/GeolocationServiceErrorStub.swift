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

public class GeolocationServiceErrorStub: GeolocationService{
    
    var errorToSend: Error!
    
    override public func getLocality() -> Observable<String?> {
        
        return Observable<String?>.create{observer in
            
            observer.onError(self.errorToSend)
            
            return Disposables.create {
            }
        }
    }
}
