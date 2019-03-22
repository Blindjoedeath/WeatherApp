//
//  LocationRouter.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import UIKit

class LocationRouter: NSObject{
    
    var weatherRouter : WeatherRouter!
    var presenter : LocationPresenter!
    var view : LocationViewController!
    
    func presentLocationInterfaceFromWindow(window: UIWindow) {
        view = locationViewControllerFromStoryboard()
        view.presenter = presenter
        presenter.view = view
        window.rootViewController = view
    }
    
    func prepare(with data: NSObject?){
        let args = data as! [NSObject]
        let board = args[0] as! UIStoryboardSegue
        let nc = board.destination as! UINavigationController
        let view = nc.topViewController as! WeatherViewController
        
        let city = args[1] as! String
        weatherRouter = WeatherRouter.build(from: view)
        weatherRouter.present(in: city)
    }
    
    func presentWeatherInterface() {
        view.performSegue(withIdentifier: "WeatherSegue", sender: nil)
    }
    
    func locationViewControllerFromStoryboard() -> LocationViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        return viewController
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard
    }
}
