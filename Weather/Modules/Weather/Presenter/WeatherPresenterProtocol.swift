//
//  WeatherPresenter.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol WeatherPresenterProtocol: class{
    func closeNavigationRequired()
    func shareNavigationRequired()
    func styleMenuNavigationRequired()
    func updateDataRequired()
    func configureView()
    func prepareToRoute(with: NSObject?)
}
