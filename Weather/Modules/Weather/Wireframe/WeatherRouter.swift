//
//  WeatherRouter.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import UIKit

protocol WeatherRouterProtocol: class {
    
    var presenter: WeatherPresenterProtocol! {get set}
    
    func route()
    func presentDayForecast()
    func unload()
}

class WeatherRouter: NSObject, WeatherRouterProtocol{
    
    var locationRouter: LocationRouter!
    
    weak var weatherViewControllerCached: WeatherViewController!
    var view: WeatherViewController! {
        get{
            if weatherViewControllerCached == nil{
                weatherViewControllerCached = presenter.view as! WeatherViewController
            }
            return weatherViewControllerCached
        }
        set{
            weatherViewControllerCached = newValue
        }
    }
    weak var presenter: WeatherPresenterProtocol!
    
    weak var dayForecastRouterCached: DayForecastRouterProtocol!
    var dayForecastRouter: DayForecastRouterProtocol!{
        get{
            if dayForecastRouterCached == nil{
                dayForecastRouterCached = DayForecastConfigurator().build(with: view!.dayForecastScrollView)
            }
            return dayForecastRouterCached
        }
        set{
            dayForecastRouterCached = newValue
        }
    }
    weak var styleRouter: StyleRouterProtocol!
    
    func route() {
        view.performSegue(withIdentifier: "StyleTableSegue", sender: {(segue: UIStoryboardSegue) in
            self.styleModuleFrom(segue: segue)
        })
    }
    
    func styleModuleFrom(segue: UIStoryboardSegue){
        let view = segue.destination as! StyleTableViewController
        styleRouter = StyleConfigurator().build(with: view)
    }
    
    func presentDayForecast(){
        dayForecastRouter.load()
    }

    func unload(){
        dayForecastRouter.unload()
        view.dismiss(animated: true, completion: nil)
        presenter = nil
    }
    
    deinit {
        print("Weather Router deinited")
    }
}
