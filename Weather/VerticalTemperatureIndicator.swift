//
//  VerticalTemperatureIndicator.swift
//  Weather
//
//  Created by Blind Joe Death on 11/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class VerticalTemperatureIndicator{
    
    private var scale : Float
    
    init(scaleOf : Float) {
        scale = scaleOf
    }
    
    func build() -> String {
        var result = ""
        let it = Int(scale * 10)        
        let lineBreaks = 9 - it
        let lines = it - 1
        
        if lineBreaks > 0 {
            for _ in 1...lineBreaks{
                result += "\n"
            }
        }
        
        if lines > 0 {
            result += "★\n"
            if lines - 1 > 0 {
                for _ in 1...lines - 1 {
                    result += "|\n"
                }
            }
            result += "|"
        } else {
            result += "★"
        }
        
        return result
    }
}
