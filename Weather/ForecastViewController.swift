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
    
    var city: String!
    private var forecast: Forecast!
    var currentWeather: Weather!
    
    func setForecastRequestResult(result: RequestResult<Forecast>){
        
        switch result {
        case .result(let forecast):
            self.forecast = forecast
            if isViewLoaded{
                loadForecast()
            }
        case .noNetwork:
            if isViewLoaded{
                let alert = getNetworkAlert()
                present(alert, animated: true, completion: nil)
            }
        case .noLocation:
            if isViewLoaded{
                let alert = getLocationAlert()
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
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
        forecastTableView.tableFooterView = UIView()
        
        let cellNib = UINib(nibName: ForecastViewIdentifiers.forecastTableViewCell, bundle: nil)
        forecastTableView.register(cellNib, forCellReuseIdentifier: ForecastViewIdentifiers.forecastTableViewCell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let forecast = forecast{
             return forecast.daysCount + 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ForecastViewIdentifiers.forecastTableViewCell) as! ForecastTableViewCell
        if indexPath.row == 0{
            cell.configure(with: currentWeather)
            cell.separatorInset = .zero
        } else{
            cell.configure(with: forecast[indexPath.row - 1][3])
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
    }
}
