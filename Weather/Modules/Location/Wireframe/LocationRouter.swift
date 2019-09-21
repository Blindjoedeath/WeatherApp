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
    var presenter: LocationPresenterProtocol! {get set}

    func route(with: Any?)
}

class LocationRouter: NSObject, LocationRouterProtocol{
    weak var presenter: LocationPresenterProtocol!
    weak var weatherRouter : WeatherRouterProtocol!
    
    func route(with data: Any?){
        let view = self.presenter.view as? LocationViewController
        view?.performSegue(withIdentifier: "WeatherSegue", sender: {(segue: UIStoryboardSegue) in
            self.nextModuleFrom(segue: segue, with: data)
        })
    }
    
    func nextModuleFrom(segue: UIStoryboardSegue, with data: Any?){
        let navigationController = segue.destination as! UINavigationController
        let weatherView = navigationController.topViewController as! WeatherViewController
        weatherRouter = WeatherConfigurator().build(with: weatherView)
    }
}
