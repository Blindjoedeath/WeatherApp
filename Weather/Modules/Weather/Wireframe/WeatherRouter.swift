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
    weak var view: WeatherViewController! {
        get{
            return presenter.view as! WeatherViewController
        }
    }
    weak var presenter: WeatherPresenterProtocol!
    weak var dayForecastRouter: DayForecastRouterProtocol!{
        get{
            return DayForecastConfigurator().build(with: view!.dayForecastScrollView)
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
