//
//  ApiUrl.swift
//  Weather
//
//  Created by Blind Joe Death on 09/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class ApiUrlService {
    static func weatherUrl(for city: String) -> URL{
        let urlString = String(format:
            "https://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@", city, weatherApiToken)
        return createUrl(for: urlString)
    }


    static func forecastUrl(for city: String) -> URL{
        let urlString = String(format:
            "https://samples.openweathermap.org/data/2.5/forecast?q=%@&appid=%@", city, weatherApiToken)
        return createUrl(for: urlString)
    }

    private static func createUrl(for urlString: String) -> URL{
        let formatted = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return URL(string: formatted)!
    }
}
