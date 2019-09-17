//
//  LocationRouterMock.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 18/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import UIKit
@testable import Weather

class LocationRouterSegueMock: LocationRouter {
    
    var segueHandler: ((UIStoryboardSegue) -> ())!
    
    override func route(with data: Any?){
        
        let view = self.presenter.view as! LocationViewController
        view.performSegue(withIdentifier: "WeatherSegue", sender: segueHandler)
    }
}
