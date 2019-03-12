//
//  ForecastViewController.swift
//  Weather
//
//  Created by Blind Joe Death on 09/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import UIKit

struct ForecastViewIdentifiers{
    static let forecastTableViewCell  = "ForecastTableViewCell"
}


class ForecastViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var currentWeatherSubstrateView: UIView!
    @IBOutlet weak var dayWeatherSubstrateView: UIView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var perceivedTemperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var dayWeatherScrollView: DayWeatherViewController!
    @IBOutlet weak var forecastTableView: UITableView!
    
    public var city: String!
    
    private var forecastVar : Forecast!
    public var forecast: Forecast! {
        set {
            if newValue != nil && forecast == nil{
                forecastVar = newValue
                if self.isViewLoaded && !forecastLoaded{
                    loadForecast()
                }
            }
        }
        get{
            return forecastVar
        }
    }
    
    public var currentWeather: Weather!
    
    func getSeason() -> String{
        let now = Date()
        return now.season
    }
    
    func seasonImage(name: String) -> UIImage?{
        return UIImage(named: name + "_" + getSeason())
    }
    
    func seasonSubstrateColor() -> UIColor{
        switch getSeason() {
        case "winter":
            return UIColor(red: 66/255.0, green: 78/255.0, blue: 198/255.0, alpha: 0.7)
        case "spring":
            return UIColor(red: 255/255.0, green: 150/255.0, blue: 204/255.0, alpha: 0.7)
        case "summer":
            return UIColor(red: 204/255.0, green: 197/255.0, blue: 109/255.0, alpha: 0.7)
        case "autumn":
            return UIColor(red: 212/255.0, green: 137/255.0, blue: 28/255.0, alpha: 0.7)
        default:
            return .clear
        }
    }
    
    func seasonNavigationBarColor() -> UIColor{
        switch getSeason() {
        case "winter":
            return UIColor(red: 48/255.0, green: 56/255.0, blue: 142/255.0, alpha: 1)
        case "spring":
            return UIColor(red: 154/255.0, green: 0/255.0, blue: 132/255.0, alpha: 1)
        case "summer":
            return UIColor(red: 161/255.0, green: 156/255.0, blue: 87/255.0, alpha: 1)
        case "autumn":
            return UIColor(red: 157/255.0, green: 102/255.0, blue: 21/255.0, alpha: 1)
        default:
            return .clear
        }
    }
    
    func loadBackground(){
        backgroundImage.image = seasonImage(name: "background")
    }
    
    func colorElements(){
        let color = seasonSubstrateColor()
        currentWeatherSubstrateView.backgroundColor = color
        dayWeatherSubstrateView.backgroundColor = color
        view.backgroundColor = color
        forecastTableView.backgroundColor = color
    }
    
    func configureSubstrate(){
        temperatureLabel.text = currentWeather.temperature.temperatureStyled
        descriptionLabel.text = currentWeather.description.firstLetterCapitalized
        perceivedTemperatureLabel.text = "Ощущается \(currentWeather.perceivedTemperature) °C"
        humidityLabel.text = "Влажность \(currentWeather.humidity)% "
        temperatureLabel.sizeToFit()
    }
    
    func configureNavigationBar(){
        navigationController!.navigationBar.barTintColor = seasonNavigationBarColor()
        navigationItem.title = city
    }
    
    private var forecastLoaded = false
    func loadForecast(){
        dayWeatherScrollView.configure(with: forecast[0])
        forecastTableView.reloadData()
        forecastLoaded = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureSubstrate()
        loadBackground()
        configureTableView()
        colorElements()
        
        if forecast != nil{
            loadForecast()
        }
    }
}


extension ForecastViewController : UITableViewDelegate, UITableViewDataSource{
    
    func configureTableView(){
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        
        let cellNib = UINib(nibName: ForecastViewIdentifiers.forecastTableViewCell, bundle: nil)
        forecastTableView.register(cellNib, forCellReuseIdentifier: ForecastViewIdentifiers.forecastTableViewCell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let forecast = forecast{
             return forecast.daysCount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastViewIdentifiers.forecastTableViewCell) as! ForecastTableViewCell
        cell.configure(with: forecast[indexPath.row][3])
        return cell
    }
}
