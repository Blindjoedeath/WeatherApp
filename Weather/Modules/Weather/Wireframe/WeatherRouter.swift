//
//  WeatherRouter.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import UIKit

protocol WeatherRouterProtocol {
    func presentDayForecast()
    func routeToStyle()
    func unload()
}

class WeatherRouter: NSObject, WeatherRouterProtocol{
    
    var locationRouter: LocationRouter!
    weak var view: WeatherViewController!
    weak var presenter: WeatherPresenter! 
    weak var dayForecastRouter: DayForecastRouter!
    var styleRouter: StyleRouter!
    
    func routeToStyle() {
        view.performSegue(withIdentifier: "StyleTableSegue", sender: {(segue: UIStoryboardSegue) in
            self.styleModuleFrom(segue: segue)
        })
    }
    
    func styleModuleFrom(segue: UIStoryboardSegue){
        let view = segue.destination as! StyleTableViewController
        styleRouter = StyleConfigurator.build(from: view)
    }
    
    func presentDayForecast(){
        dayForecastRouter = DayForecastConfigurator.build(from: view.dayForecastScrollView)
        presenter.delegate = dayForecastRouter.presenter
    }
    
    func presentStyleMenu(){
        view.performSegue(withIdentifier: "StyleTableSegue", sender: nil)
    }

    func unload(){
        view.dismiss(animated: true, completion: nil)
        
        presenter = nil
        view = nil
    }
    
    deinit {
        print("Weather Router deinited")
    }
}
