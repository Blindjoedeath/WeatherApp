//
//  DayWeatherViewController.swift
//  Weather
//
//  Created by Blind Joe Death on 11/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import UIKit

class DayWeatherViewController: UIScrollView {
    
    private var dayWeather: [Weather]!
    
    private var cellWidth: Int = 52
    private var indent = 10
    
    func resizeView(){
        var size = self.frame.size
        size.width = CGFloat(cellWidth * dayWeather.count + 2 * indent)
        self.contentSize = size
    }
    
    func drawHourBins(){
        for (i, weather) in dayWeather.enumerated(){
            let hourBinView = Bundle.main.loadNibNamed("HourBinView", owner: self, options: nil)?.first as! HourBinView
            self.addSubview(hourBinView)
            
            var frame = hourBinView.frame
            
            frame.origin.x = CGFloat(indent + i * cellWidth)
            hourBinView.frame = frame
            
            let position : Position = i == 0 ? .right : (i == dayWeather.count-1 ? .left : .center)
            hourBinView.configure(with: weather, on: position)
        }
    }
    
    func configure(with dayWeather: [Weather]!) {
        self.dayWeather = dayWeather + dayWeather + dayWeather
        resizeView()
        drawHourBins()
    }
}
