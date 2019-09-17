//
//  WeatherRouterSegueMock.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 18/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import UIKit
@testable import Weather

class WeatherRouterSegueMock: WeatherRouter {
    
    var segueHandler: ((UIStoryboardSegue) -> ())!
    
    override func route(){
        let view = self.presenter.view as! WeatherViewController
        view.performSegue(withIdentifier: "StyleTableSegue", sender: segueHandler)
    }
}
