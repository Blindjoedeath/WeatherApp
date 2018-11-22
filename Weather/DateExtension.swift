//
//  DateExtension.swift
//  Weather
//
//  Created by Blind Joe Death on 22/11/2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import Foundation

extension Date {
    func day() -> String {
        return formatted(by: "EEEE")
    }
    
    func formatted(by format: String) -> String{
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.string(from: now)
    }
    
    func shortDate() -> String {
        switch day() {
        case "понедельник":
            return "Пн"
        case "вторник":
            return "Вт"
        case "среда":
            return "Ср"
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
