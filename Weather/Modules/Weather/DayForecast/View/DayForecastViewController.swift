//
//  DayWeatherViewController.swift
//  Weather
//
//  Created by Blind Joe Death on 11/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import UIKit

class DayForecastViewController: UIScrollView, DayForecastViewProtocol {
    
    var presenter: DayForecastPresenterProtocol!
    var dayForecast: [WeatherItem]!
    
    var cellWidth: Int = 52
    var indent = 8
    var updatingIndicator: UIActivityIndicatorView!
    var hourBinViews: [HourBinView]!
    var initialSize: CGSize!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSize = self.frame.size
        initUpdatingLocationIndicator()
    }
    
    func initUpdatingLocationIndicator(){
        updatingIndicator = UIActivityIndicatorView(frame: bounds)
        updatingIndicator.style = .whiteLarge
        updatingIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(updatingIndicator)
    }
    
    var isUpdatingIndicatorEnabled: Bool {
        get {
            return !updatingIndicator.isAnimating
        }
        set {
            UIApplication.shared.isNetworkActivityIndicatorVisible = newValue
            if newValue{
                updatingIndicator.startAnimating()
            } else{
                updatingIndicator.stopAnimating()
            }
        }
    }
    
    var itemsEnabledVar = false
    var isItemsEnabled: Bool {
        get{
            return itemsEnabledVar
        }
        set{
            if let hourBinViews = hourBinViews{
                itemsEnabledVar = newValue
                for hourBinView in hourBinViews{
                    hourBinView.isHidden = !itemsEnabledVar
                }
            }
        }
    }
    
    func resizeViewToinitialSize(){
        self.contentSize = initialSize
    }
    
    func resizeViewToData(){
        var size = self.frame.size
        size.width = CGFloat(cellWidth * dayForecast.count + 2 * indent)
        self.contentSize = size
    }
    
    func configureHourBins(){
        let indicatorScales = calculateIndicatorScales()
        
        var firstTime = false
        if hourBinViews == nil{
            hourBinViews = [HourBinView]()
            firstTime = true
        }
        
        for (i, weather) in dayForecast.enumerated(){
            var hourBinView: HourBinView!
            if firstTime{
                hourBinView = Bundle.main.loadNibNamed("HourBinView", owner: self, options: nil)?.first as! HourBinView
                hourBinViews.append(hourBinView)
            } else{
                hourBinView = hourBinViews[i]
            }
            
            self.addSubview(hourBinView)
            
            var frame = hourBinView.frame
            
            frame.origin.x = CGFloat(indent + i * cellWidth)
            hourBinView.frame = frame
            let position : Position = i == 0 ? .left : (i == dayForecast.count-1 ? .right : .center)
            let hourBinInfo = HourBinInfo(position: position,
                                          indicatorHeight: Int(indicatorScales[i] * 10),
                                          weather: weather)
            hourBinView.configure(with: hourBinInfo)
        }
    }
    
    func animateAppearance(){
        configureHourBins()
        isAnimating = true
        animateСonsistently(for: hourBinViews)
    }
    
    private(set) var isAnimating : Bool = false
    
    func animateСonsistently(for hourBinViews: [HourBinView], arg : Int = 0){
        if isAnimating{
            if arg == hourBinViews.count{
                return
            } else{
                hourBinViews[arg].animateAppearance{
                    self.animateСonsistently(for: hourBinViews, arg: arg + 1)
                }
            }
        }
    }
    
    func cancelAnimation(){
        isAnimating = false
        if let hourBinViews = hourBinViews{
            for hourBinView in hourBinViews{
                hourBinView.calcelAnimation()
            }
        }
    }
    
    func configure(with dayForecast: [WeatherItem]) {
        self.dayForecast = dayForecast
    }

    func calculateIndicatorScales() -> [Float]{
        let absTemperatures = dayForecast!.map{abs(Int($0.temperature)!)}
        let average = Float(absTemperatures.reduce(0, +)) / Float(absTemperatures.count)
        
        var result = [Float]()
        for temp in absTemperatures{
            var value : Float = 0.5
            if average != 0 {
                value += (Float(temp) - average) / (3 * average)
                value = value > 1 ? 1 : value
                value = value < 0 ? 0 : value
            }
            result.append(value)
        }
        return result
    }
    
    deinit{
        print("day forecast view deinit")
    }
}
