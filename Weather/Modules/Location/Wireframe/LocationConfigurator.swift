//
//  LocationAssembly.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class LocationConfigurator: NSObject {
    
    static func build(with view: LocationViewController) -> LocationRouter {
        let router = LocationRouter()
        let presenter = LocationPresenter()
        let interactor = LocationInteractor()
        
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
        
        view.presenter = presenter
        
        interactor.output = presenter
        
        router.view = view
        
        return router
    }
}
