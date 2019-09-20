//
//  Router.swift
//  Weather
//
//  Created by Blind Joe Death on 22/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol DayForecastRouterProtocol: class{
    var presenter: DayForecastPresenterProtocol! {get set}
    
    func load()
    func unload()
}

class DayForecastRouter: NSObject, DayForecastRouterProtocol{
    
    weak var presenter: DayForecastPresenterProtocol!
    
    func load(){
        presenter.load()
    }
    
    func unload() {
        presenter.unload()
    }
}
