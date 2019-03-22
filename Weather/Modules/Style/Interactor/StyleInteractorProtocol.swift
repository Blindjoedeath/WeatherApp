//
//  StyleInteractorProtocol.swift
//  Weather
//
//  Created by Blind Joe Death on 22/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol StyleInteractorProtocol: class {
    func getStyle() -> AppStyleModel
    func setStyle(name: String)
    func getAllStyles() -> [AppStyleModel]
}
