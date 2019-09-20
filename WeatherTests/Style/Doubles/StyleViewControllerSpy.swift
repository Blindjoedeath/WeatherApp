//
//  StyleViewControllerSpy.swift
//  WeatherTests
//
//  Created by Oskar on 20/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather

class StyleViewControllerSpy: StyleTableViewController{
    
    var invokedDissmiss: Bool = false
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        invokedDissmiss = true
    }
}
