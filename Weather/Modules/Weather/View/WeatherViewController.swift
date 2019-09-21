//
//  File.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import UIKit


protocol WeatherViewProtocol: class{
    
    var presenter: WeatherPresenterProtocol! {get set}
    
    func showAlert(title: String, message: String)
    func setTitle(title: String)
    
    func setAppStyle(style: AppStyle)
    func setCurrentWeather(weather: WeatherItem)
    func setWeekForecastData(forecast: [WeatherItem])
    func shareImage(with: String)
    func close()
    
    var isUpdateIndicatorEnabled: Bool {get set}
}


struct WeatherViewIdentifiers{
    static let tableViewCell  = "WeatherTableViewCell"
    static let kuranovSpinnerView = "KuranovSpinnerView"
}

class WeatherViewController: UIViewController{
    
    var presenter: WeatherPresenterProtocol!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var currentWeatherSubstrateView: UIView!
    @IBOutlet weak var dayWeatherSubstrateView: UIView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var perceivedTemperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var dayForecastScrollView: DayForecastViewController!
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var styleButton: UIButton!
    
    var weekForecast: [WeatherItem]?
    
    weak var kuranovSpinnerView: KuranovSpinnerView!
    weak var refreshControl: UIRefreshControl!
    weak var titleView: UILabel!
    
    private func createTapableTitle() {
        let titleView = UILabel()
        titleView.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        let width = titleView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
        titleView.frame = CGRect(origin:CGPoint.zero, size:CGSize(width: width, height: 500))
        self.navigationItem.titleView = titleView
        titleView.textColor = .white
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(titleWasTapped))
        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(recognizer)
        
        self.titleView = titleView
    }
    
    @objc
    private func titleWasTapped() {
        presenter.styleMenuNavigationRequired()
    }
    
    func addRefreshControl(){
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.clear
        refreshControl.backgroundColor = UIColor.clear
        
        let kuranovSpinnerView = Bundle.main.loadNibNamed(WeatherViewIdentifiers.kuranovSpinnerView,
                                                      owner: self, options: nil)?.first as! KuranovSpinnerView
        
        refreshControl.addSubview(kuranovSpinnerView)
        
        kuranovSpinnerView.frame = refreshControl.frame
        kuranovSpinnerView.backgroundColor = UIColor.clear
        mainScrollView.refreshControl = refreshControl
        
        self.refreshControl = refreshControl
        self.kuranovSpinnerView = kuranovSpinnerView
    }
    
    func colorElements(with color: UIColor){
        currentWeatherSubstrateView.backgroundColor = color
        dayWeatherSubstrateView.backgroundColor = color
        view.backgroundColor = color
        forecastTableView.backgroundColor = color
    }
    
    override func viewDidLoad() {
        addRefreshControl()
        createTapableTitle()
        configureTableView()
        mainScrollView.delegate = self
        
        presenter.configureView()
        
        forecastTableView.reloadData()
    }
    
    @IBAction func closeButtonAction(){
        presenter.closeNavigationRequired()
    }
    
    @IBAction func shareButtonAction(){
        presenter.shareNavigationRequired()
    }
    
    func createShareImage() -> UIImage{
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 320, height: 340))
        
        let image = renderer.image { ctx in
            backgroundImage.image!.draw(in: view.bounds, blendMode: .normal, alpha: 1)
            let bounds = CGRect(x: 0, y: 70, width: 320, height: 116)
            currentWeatherSubstrateView.drawHierarchy(in: bounds, afterScreenUpdates: true)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let font = UIFont(name: "HelveticaNeue-Medium", size: 18)!
            let attrs = [NSAttributedString.Key.font: font,
                         NSAttributedString.Key.paragraphStyle: paragraphStyle,
                         NSAttributedString.Key.foregroundColor: UIColor.white]
            let strBounds = CGRect(x: 0, y: 35, width: 320, height: 340)
            titleView!.text!.draw(with: strBounds, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        }
        return image
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let closure = sender as! (UIStoryboardSegue) -> ()
        closure(segue)
    }
    
    func close(){
        mainScrollView.delegate = nil
        mainScrollView = nil
        forecastTableView.delegate = nil
        
        kuranovSpinnerView.stopAnimation(completion: {})
    }
    
    deinit {
        print("Weather View deinited")
    }
}

extension WeatherViewController: WeatherViewProtocol{
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default,
                                     handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func setTitle(title: String) {
        titleView.text = title
    }
    
    func setAppStyle(style: AppStyle) {
        let color = style.color.withAlphaComponent(0.7)
        colorElements(with: color)
        
        navigationController?.navigationBar.barTintColor = seasonNavigationBarColor(for: style.name)
        backgroundImage.image = UIImage(named: "background_" + style.name)
    }
    
    func setCurrentWeather(weather: WeatherItem) {
        temperatureLabel.text = weather.temperature
        descriptionLabel.text = weather.description
        perceivedTemperatureLabel.text = "Ощущается \(weather.perceivedTemperature) °C"
        humidityLabel.text = "Влажность \(weather.humidity)% "
        temperatureLabel.sizeToFit()
    }
    
    func setWeekForecastData(forecast: [WeatherItem]) {
        weekForecast = forecast
        forecastTableView.reloadData()
    }
    
    func shareImage(with message: String) {
        let image = createShareImage()
        let url = image.save("share.jpeg")
        
        let objectsToShare = [message, url] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    var isUpdateIndicatorEnabled: Bool{
        get{
            return refreshControl.isRefreshing
        }
        set{
            UIApplication.shared.isNetworkActivityIndicatorVisible = newValue
            if newValue{
                refreshControl.beginRefreshing()
                kuranovSpinnerView.startAnimation()
            } else{
                kuranovSpinnerView.stopAnimation {
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }
}

extension WeatherViewController: UIScrollViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < -150 {
            if  !kuranovSpinnerView.isAnimating {
                presenter.updateDataRequired()
            }
        }
    }
}

extension WeatherViewController : UITableViewDelegate, UITableViewDataSource{
    
    func configureTableView(){
        forecastTableView.delegate = self
        forecastTableView.dataSource = self
        forecastTableView.tableFooterView = UIView()
        
        let cellNib = UINib(nibName: WeatherViewIdentifiers.tableViewCell, bundle: nil)
        forecastTableView.register(cellNib, forCellReuseIdentifier:
                                            WeatherViewIdentifiers.tableViewCell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let weekForecast = weekForecast{
            return weekForecast.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherViewIdentifiers.tableViewCell) as! WeatherTableViewCell
        if indexPath.row == 0 {
            cell.separatorInset = .zero
        } else {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        if let weekForecast = weekForecast{
            cell.configure(with: weekForecast[indexPath.row])
        }
        return cell
    }
}

