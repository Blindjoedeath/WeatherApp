//
//  SeasonStyle.swift
//  Weather
//
//  Created by Blind Joe Death on 14/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import UIKit

struct AppStyle{
    var name: String
    var description: String
    var color: UIColor
}

extension AppStyle: Equatable{
    
    static func ==(lhs: AppStyle, rhs: AppStyle) -> Bool {
        return lhs.name == rhs.name &&
               lhs.description == rhs.description &&
               lhs.color == rhs.color
    }
    
}

