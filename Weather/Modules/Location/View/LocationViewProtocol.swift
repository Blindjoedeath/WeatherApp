//
//  LocationView.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol LocationViewProtocol: class {
    
    func showAlert(title: String, message: String)
    func setCurrentDate(date: String)
    func setToday(day: String)
    func setCity(city: String)
    
    var isNextNavigationEnabled: Bool {get set}
    var isPermissionNotificationEnabled: Bool {get set}
    var isDataLoadingIndicatorEnabled: Bool {get set}
}
