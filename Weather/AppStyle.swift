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

var appStyles: [AppStyleName : AppStyle] = {
    var result: [AppStyleName : AppStyle] = [:]
    result[.winter] = AppStyle(name: "winter",
                              description: "Зима",
                              color: UIColor(red: 66/255.0, green: 78/255.0, blue: 198/255.0, alpha: 1))
    result[.spring] = AppStyle(name: "spring",
                              description: "Весна",
                              color: UIColor(red: 255/255.0, green: 150/255.0, blue: 204/255.0, alpha: 1))
    result[.summer] = AppStyle(name: "summer",
                              description: "Лето",
                              color: UIColor(red: 204/255.0, green: 197/255.0, blue: 109/255.0, alpha: 1))
    result[.autumn] = AppStyle(name: "autumn",
                              description: "Осень",
                              color: UIColor(red: 212/255.0, green: 137/255.0, blue: 28/255.0, alpha: 1))
    return result
}()


