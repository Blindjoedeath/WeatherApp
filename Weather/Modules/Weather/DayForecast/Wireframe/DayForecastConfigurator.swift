//
//  DayForecastConfigurator.swift
//  Weather
//
//  Created by Oskar on 09/07/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class DayForecastConfigurator{
    
    static func build(from view: DayForecastViewController) -> DayForecastRouter{
        let router = DayForecastRouter()
        let presenter = DayForecastPresenter()
        
        presenter.router = router
        view.presenter = presenter
        presenter.view = view
        router.view = view
        router.presenter = presenter
        return router
    }
}
