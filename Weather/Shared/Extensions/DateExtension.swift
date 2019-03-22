//
//  DateExtension.swift
//  Weather
//
//  Created by Blind Joe Death on 22/11/2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import Foundation

extension Date {
    var dayName : String {
        get{
            return formatted(by: "EEEE")
        }
    }
    
    var day : String{
        get{
            return formatted(by: "YYYY-MM-dd")
        }
    }
    
    var hour : String{
        get{
            return formatted(by: "HH:mm")
        }
    }
    
    func formatted(by format: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.string(from: self)
    }
    
    var shortDayName : String {
        get{
            switch self.dayName {
            case "понедельник":
                return "пн"
            case "вторник":
                return "вт"
            case "среда":
                return "ср"
            case "четверг":
                return "чт"
            case "пятница":
                return "пн"
            case "суббота":
                return "сб"
            case "воскресенье":
                return "вс"
            default:
                return ""
            }
        }
    }
    
    var season : String{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM"
            let numberOfMonth = Int(dateFormatter.string(from: self))!
            
            switch numberOfMonth {
            case 12, 1, 2:
                return "winter"
            case 3...5:
                return "spring"
            case 6...8:
                return "summer"
            case 9...11:
                return "autumn"
            default:
                return ""
            }
        }
    }
}
