//
//  Router.swift
//  Weather
//
//  Created by Blind Joe Death on 22/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class DayForecastRouter: NSObject{
    
    weak var view: DayForecastViewController!
    weak var presenter: DayForecastPresenter!
    
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
    
    deinit {
        print("day forecast router deinited")
    }
}
