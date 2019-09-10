//
//  LocationRouter.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import UIKit

protocol LocationRouterProtocol{
    func route(with: Any?)
}

class LocationRouter: NSObject, LocationRouterProtocol{
    
    var weatherRouter : WeatherRouterProtocol!
    var view : LocationViewController!
    var presenter: LocationPresenter!
    
    func route(with data: Any?){
        
        view.performSegue(withIdentifier: "WeatherSegue", sender: {(segue: UIStoryboardSegue) in
            self.nextModuleFrom(segue: segue, with: data)
        })
    }
    
    func nextModuleFrom(segue: UIStoryboardSegue, with data: Any?){
        let navigationController = segue.destination as! UINavigationController
        let weatherView = navigationController.topViewController as! WeatherViewController
        weatherRouter = WeatherConfigurator.build(from: weatherView)
    }
}
