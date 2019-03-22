//
//  File.swift
//  Weather
//
//  Created by Blind Joe Death on 20/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol WeatherRequestStorageDelegate: class {
    func weatherDidSet()
    func forecastDidSet()
}

class WeatherRequestStorage{
    
    private static var delegates: [WeatherRequestStorageDelegate] = []
    
    private static var weatherVar: RequestResult<Weather>?
    static var weather: RequestResult<Weather>?{
        get{
            return weatherVar
        }
        set{
            weatherVar = newValue
            for delegate in delegates{
                delegate.weatherDidSet()
            }
        }
    }
    
    private static var forecastVar: RequestResult<Forecast>?
    static var forecast: RequestResult<Forecast>?{
        get{
            return forecastVar
        }
        set{
            forecastVar = newValue
            for delegate in delegates{
                delegate.forecastDidSet()
            }
        }
    }
    
    static func registerDelegate(my delegateSelf: WeatherRequestStorageDelegate){
        if !delegates.contains{$0 === delegateSelf}{
            delegates.append(delegateSelf)
        }
    }
    
    static func unregisterDelegate(my delegateSelf: WeatherRequestStorageDelegate){
        delegates = delegates.filter{$0 !== delegateSelf}
    }
    
    static func clear(){
        weather = nil
        forecast = nil
    }
}
