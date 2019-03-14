//
//  AppStyle.swift
//  Weather
//
//  Created by Blind Joe Death on 14/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
enum AppStyleName: Int{
    case winter = 0, spring = 1, summer = 2, autumn = 3
}

class AppStyleController{
    static var currentStyle: AppStyle = appStyles[.winter]!
}
