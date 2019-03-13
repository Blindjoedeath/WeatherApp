//
//  ErrorNotification.swift
//  Weather
//
//  Created by Blind Joe Death on 13/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import UIKit

func getNetworkAlert() -> UIAlertController {
    let alert = UIAlertController(title: "Опаньки...",
                                  message: "Проверьте соединение.",
                                  preferredStyle: .alert)
    
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    return alert
}

func getLocationAlert() -> UIAlertController {
    let alert = UIAlertController(title: "Опаньки...",
                                  message: "Город не найден.",
                                  preferredStyle: .alert)
    
    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(action)
    return alert
}
