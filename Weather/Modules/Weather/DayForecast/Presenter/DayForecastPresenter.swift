//
//  DayForecastPresenter.swift
//  Weather
//
//  Created by Blind Joe Death on 22/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol DayForecastPresenterProtocol: class {
    
}

class DayForecastPresenter:  DayForecastPresenterProtocol{
    
    weak var view: DayForecastViewProtocol!
    var router: DayForecastRouter!
    
    func updateWith(data items: [WeatherItem]) {
        view.configure(with: items)
    }
    
    func animateDataAppearance() {
        if view.isAnimating{
            view.cancelAnimation()
        }
        view.resizeViewToData()
        view.isItemsEnabled = true
        view.animateAppearance()
    }
    
    func cancelAppearanceAnimation() {
        view.cancelAnimation()
    }
    
    var isUpdatingIndicatorEnabled: Bool{
        get{
            return view.isUpdatingIndicatorEnabled
        }
        set{
            if newValue{
                view.isItemsEnabled = false
                view.resizeViewToinitialSize()
            }
            view.isUpdatingIndicatorEnabled = newValue
        }
    }
    
    deinit {
        //print("day forecast presenter deinit")
    }
}
