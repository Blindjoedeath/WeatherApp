//
//  AppStyle.swift
//  Weather
//
//  Created by Blind Joe Death on 14/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class AppStyleController{
    
    static func changeStyle(by name: String){
        currentStyle = appStyles[name]!
        UserDefaults.standard.set(currentStyle.name, forKey: "appStyle")
    }
    
    private static func getSeason() -> String{
        let now = Date()
        return now.season
    }
    
    private (set) static var currentStyle: AppStyle = {
        if let style = UserDefaults.standard.string(forKey: "appStyle"){
            return appStyles[style]!
        } else {
            return appStyles[getSeason()]!
        }
    }()
}
