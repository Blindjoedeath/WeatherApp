//
//  WeatherPresenterDelegate.swift
//  Weather
//
//  Created by Blind Joe Death on 22/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol WeatherPresenterDelegate: class {
    func updateWith(data forecast: [WeatherItem])
    func animateDataAppearance()
    func cancelAppearanceAnimation()
    
    var isUpdatingIndicatorEnabled: Bool {get set}
}
