//
//  ForecastTableViewCell.swift
//  Weather
//
//  Created by Blind Joe Death on 12/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempAndHumidityLabel: UILabel!
    @IBOutlet weak var iconImageview: UIImageView!
    
    func configure(with weather: WeatherItem) {
        
        if weather.date == "Сегодня" {
            todayLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
            todayLabel.textAlignment = .left
        } else {
            todayLabel.textAlignment = .center
        }
        todayLabel.text = weather.date
        weatherDescriptionLabel.text = weather.description
        tempAndHumidityLabel.text = "\(weather.temperature) / \(weather.humidity)%"
        iconImageview.image = UIImage(named: "weather_icons/" + weather.iconCode)
    }
}
