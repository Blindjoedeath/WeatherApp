//
//  AppStyle.swift
//  Weather
//
//  Created by Blind Joe Death on 14/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class AppStyleService{
    
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
    
    private(set) static var appStyles: [String : AppStyle] = {
        var result: [String : AppStyle] = [:]
        result["winter"] = AppStyle(name: "winter",
                                    description: "Зима",
                                    color: AppColor(r: 66/255.0, g: 78/255.0, b: 198/255.0))
        result["spring"] = AppStyle(name: "spring",
                                    description: "Весна",
                                    color: AppColor(r: 255/255.0, g: 150/255.0, b: 204/255.0))
        result["summer"] = AppStyle(name: "summer",
                                    description: "Лето",
                                    color: AppColor(r: 204/255.0, g: 197/255.0, b: 109/255.0))
        result["autumn"] = AppStyle(name: "autumn",
                                    description: "Осень",
                                    color: AppColor(r: 212/255.0, g: 137/255.0, b: 28/255.0))
        return result
    }()

}
