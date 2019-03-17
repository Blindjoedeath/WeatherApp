//
//  HourBinViewController.swift
//  Weather
//
//  Created by Blind Joe Death on 11/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import UIKit

enum Position {
    case left, center, right
}

struct HourBinInfo{
    var position: Position
    var indicatorHeight: Int
    var weather: Weather
}

class HourBinView: UIView {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var verticalIndicatorLabel: UILabel!
    @IBOutlet weak var horizontalBorderingLabel: UILabel!
    
    private var isAnimationStopped = false
    private var isAnimating = false
    private var hourBinInfo: HourBinInfo!
    
    
    func delegateAnimation(animation: () -> Void){
        if isAnimating {
            animation()
        } else if !isAnimationStopped{
            verticalIndicatorLabel.text = ""
            horizontalBorderingLabel.text = ""
            isAnimationStopped = true
        }
    }
    
    func animateAppearance(completion: @escaping () -> Void){
        isAnimating = true
        isAnimationStopped = false
        
        for i in 1...hourBinInfo.indicatorHeight{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.03 * Double(i)){ [weak self] in
                self?.delegateAnimation {
                    self?.verticalIndicatorLabel.text = VerticalTemperatureIndicator(height: i).build()
                }
            }
        }
        
        let border = makeHorizontalBorder(position: hourBinInfo.position)
        for i in 1...border.count-1{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.015 * Double(i)){ [weak self] in
                self?.delegateAnimation {
                    let index = border.index(border.startIndex, offsetBy: i)
                    self?.horizontalBorderingLabel.text = String(border[border.startIndex...index])
                    if i == border.count - 1{
                        completion()
                    }
                }
            }
        }
    }
    
    func calcelAnimation(){
        isAnimating = false
    }
    
    func configure(with hourBinInfo: HourBinInfo) {
        self.hourBinInfo = hourBinInfo
        
        iconImageView.image = hourBinInfo.weather.icon
        temperatureLabel.text = "\(hourBinInfo.weather.temperature)°C"
        hourLabel.text = hourBinInfo.weather.date!.hour
        horizontalBorderingLabel.text = ""
        verticalIndicatorLabel.text = ""
        
        alignHorizontalBorder()
    }
    
    func alignHorizontalBorder(){
        if hourBinInfo.position == .center {
            horizontalBorderingLabel.textAlignment = .left
        } else if hourBinInfo.position == .left {
            horizontalBorderingLabel.textAlignment = .right
        } else {
            horizontalBorderingLabel.textAlignment = .left
        }
    }
    
    func makeHorizontalBorder(position: Position) -> String {
        if position == .center {
            return "_ _ _ _  _ _ _ _"
        } else if position == .left {
            return "           _ _ _ _"
        }
        return " _ _ _ _"
    }
    
    deinit {
        print(" Deinited hour bin view ")
    }
}
