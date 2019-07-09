//
//  Router.swift
//  Weather
//
//  Created by Blind Joe Death on 22/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol DayForecastRouterProtocol{
    
}

class DayForecastRouter: NSObject, DayForecastRouterProtocol{
    
    weak var view: DayForecastViewController!
    weak var presenter: DayForecastPresenter!
    
    deinit {
        print("day forecast router deinited")
    }
}
