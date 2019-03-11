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

class HourBinView: UIView {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var verticalIndicatorLabel: UILabel!
    @IBOutlet weak var horizontalBorderingLabel: UILabel!

    
    func configure(with weather : Weather, on position: Position) {
        iconImageView.image = weather.icon
        temperatureLabel.text = "\(weather.temperature)°C"
        hourLabel.text = weather.date!.hour
        verticalIndicatorLabel.text = VerticalTemperatureIndicator(scaleOf: 0.2).build()
        makeHorizontalLabel(position: position)
    }
    
    func makeHorizontalLabel(position: Position) {
        if position == .center {
            horizontalBorderingLabel.textAlignment = .center
            horizontalBorderingLabel.text = "_ _ _ _  _ _ _ _"
        } else if position == .left {
            horizontalBorderingLabel.textAlignment = .center
            horizontalBorderingLabel.text = "           _ _ _ _"
        } else {
            horizontalBorderingLabel.textAlignment = .left
            horizontalBorderingLabel.text = " _ _ _ _"
        }
    }
}
