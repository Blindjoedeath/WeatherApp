//
//  File.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import UIKit

func seasonNavigationBarColor(for season: String) -> UIColor{
    switch season {
    case "winter":
        return UIColor(red: 48/255.0, green: 56/255.0, blue: 142/255.0, alpha: 1)
    case "spring":
        return UIColor(red: 154/255.0, green: 0/255.0, blue: 132/255.0, alpha: 1)
    case "summer":
        return UIColor(red: 161/255.0, green: 156/255.0, blue: 87/255.0, alpha: 1)
    case "autumn":
        return UIColor(red: 157/255.0, green: 102/255.0, blue: 21/255.0, alpha: 1)
    default:
        return .clear
    }
}
