//
//  WeatherRouter.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import UIKit

class WeatherRouter: NSObject{
    
    var locationRouter: LocationRouter!
    weak var view: WeatherViewController!
    weak var presenter: WeatherPresenter! 
    weak var dayForecastRouter: DayForecastRouter!
    var styleRouter: StyleRouter!
    
    func present(in city: String){
        presenter.configure(with: city)
    }
    
    func presentDayForecast(){
        dayForecastRouter = DayForecastRouter.build(from: view.dayForecastScrollView)
        presenter.delegate = dayForecastRouter.presenter
    }
    
    func presentStyleMenu(){
        view.performSegue(withIdentifier: "StyleTableSegue", sender: nil)
    }
    
    func pepareStyleMenu(from segue: NSObject?){
        let board = segue as! UIStoryboardSegue
        let view = board.destination as! StyleTableViewController
        
        styleRouter = StyleRouter.build(from: view)
        styleRouter.presenter.delegate = presenter
    }

    func close(){
        view.dismiss(animated: true, completion: nil)
        
        presenter = nil
        view = nil
    }
    
    static func build(from weatherView: WeatherViewController) -> WeatherRouter {
        let router = WeatherRouter()
        let presenter = WeatherPresenter()
        let interactor = WeatherInteractor()
        let view = weatherView
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter
        router.presenter = presenter
        router.view = view
        return router
    }
    
    deinit {
        print("Weather Router deinited")
    }
}
