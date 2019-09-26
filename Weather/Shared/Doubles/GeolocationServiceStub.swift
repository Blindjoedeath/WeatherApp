//
//  GeolocationServiceStub.swift
//  Weather
//
//  Created by Oskar on 26/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import RxSwift

class GeolocationServiceStub: GeolocationService{
    
    static var instance = GeolocationServiceStub()
    
    private override init(){}
    
    var stubbedLocality: String!
    
    override var access: Observable<Bool>{
        return Observable.of(true)
    }
    
    override func getLocality() -> Observable<String?> {
        return Observable.of(stubbedLocality)
    }
}
