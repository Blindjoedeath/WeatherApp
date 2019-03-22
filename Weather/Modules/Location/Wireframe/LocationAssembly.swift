//
//  LocationAssembly.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class LocationAssembly: NSObject {
    
    static func build() -> LocationRouter {
        let router = LocationRouter()
        let presenter = LocationPresenter()
        let interactor = LocationInteractor()
        
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.presenter = presenter
        return router
    }
}
