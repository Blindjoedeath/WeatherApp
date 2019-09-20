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
    
    var presenter: WeatherPresenterProtocol! {get set}
    
    func route()
    func presentDayForecast()
    func unload()
}

class WeatherRouter: NSObject, WeatherRouterProtocol{
    
    var locationRouter: LocationRouter!
    var view: WeatherViewController{
        get{
            return presenter.view as! WeatherViewController
        }
    }
    weak var presenter: WeatherPresenterProtocol!
    lazy var dayForecastRouter: DayForecastRouterProtocol! = {
        DayForecastConfigurator().build(with: view.dayForecastScrollView)
    }()
    var styleRouter: StyleRouter!
    
    func route() {
        view.performSegue(withIdentifier: "StyleTableSegue", sender: {(segue: UIStoryboardSegue) in
            self.styleModuleFrom(segue: segue)
        })
    }
    
    func styleModuleFrom(segue: UIStoryboardSegue){
        let view = segue.destination as! StyleTableViewController
        styleRouter = StyleConfigurator.build(from: view)
    }
    
    func presentDayForecast(){
        dayForecastRouter.load()
    }
    
    func presentStyleMenu(){
        view.performSegue(withIdentifier: "StyleTableSegue", sender: nil)
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
