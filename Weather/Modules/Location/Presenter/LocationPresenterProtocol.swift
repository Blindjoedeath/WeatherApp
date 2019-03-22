//
//  LocationPresenterProtocol.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol LocationPresenterProtocol: class {
    func cityNameChanged(on: String)
    
    // or button clicked
    func nextNavigationRequired(with: String)
    func geolocationRequired()
    
    func prepareToRoute(with: NSObject?)
    func configureView()
}
