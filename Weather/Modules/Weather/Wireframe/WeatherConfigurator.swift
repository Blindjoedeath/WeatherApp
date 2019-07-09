//
//  WeatherAssembly.swift
//  Weather
//
//  Created by Oskar on 09/07/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class WeatherConfigurator{
    
    static func build(from view: WeatherViewController) -> WeatherRouter {
        let router = WeatherRouter()
        let presenter = WeatherPresenter()
        let interactor = WeatherInteractor()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.output = presenter
        
        router.presenter = presenter
        router.view = view
        return router
    }
}
