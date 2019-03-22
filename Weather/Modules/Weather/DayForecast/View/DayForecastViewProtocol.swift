//
//  DayForecastViewProtocol.swift
//  Weather
//
//  Created by Blind Joe Death on 22/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol DayForecastViewProtocol: class {
    func cancelAnimation()
    func animateAppearance()
    func configure(with: [WeatherItem])
    func resizeViewToinitialSize()
    func resizeViewToData()
    
    var isAnimating: Bool {get }
    var isUpdatingIndicatorEnabled: Bool {get set}
    var isItemsEnabled: Bool {get set}
}
