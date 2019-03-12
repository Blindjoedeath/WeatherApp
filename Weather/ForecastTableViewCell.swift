//
//  ForecastTableViewCell.swift
//  Weather
//
//  Created by Blind Joe Death on 12/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var tempAndHumidityLabel: UILabel!
    @IBOutlet weak var iconImageview: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with weather: Weather) {
        
        if weather.date == nil {
            todayLabel.text = "Сегодня"
            todayLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
            todayLabel.textAlignment = .left
        } else {
            todayLabel.text = weather.date!.shortDayName
            todayLabel.textAlignment = .center
        }
        weatherDescriptionLabel.text = weather.description
        tempAndHumidityLabel.text = "\(weather.temperature.temperatureStyled) / \(weather.humidity)%"
        iconImageview.image = weather.icon
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }

}
