//
//  IntExtension.swift
//  Weather
//
//  Created by Blind Joe Death on 10/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

internal extension Int{
    var temperatureStyled: String {
        get{
            return self > 0 ? "+\(self)" : "\(self)"
        }
    }
}
