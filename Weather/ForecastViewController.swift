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
    static let kuranovSpinnerView = "KuranovSpinnerView"
}

class ForecastViewController: UIViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var currentWeatherSubstrateView: UIView!
    @IBOutlet weak var dayWeatherSubstrateView: UIView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var perceivedTemperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var dayWeatherScrollView: DayWeatherViewController!
    @IBOutlet weak var forecastTableView: UITableView!
    @IBOutlet weak var styleButton: UIButton!
    
    var kuranovSpinnerView: KuranovSpinnerView!
    var refreshControl: UIRefreshControl!
    var city: String!
    private var forecast: Forecast!
    var currentWeather: Weather!
    
    private var style: AppStyle!
    
    func setForecastRequestResult(result: RequestResult<Forecast>){
        
        print(result)
        
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
    
    @IBAction func closeButtonAction(){
        
        mainScrollView.delegate = nil
        mainScrollView = nil

        dismiss(animated: true, completion: nil)
        
        dayWeatherScrollView.cancelAnimation()
        kuranovSpinnerView.stopAnimation(completion:{})
//        kuranovSpinnerView = nil
    }
    
    func seasonNavigationBarColor() -> UIColor{
        switch style.name {
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
    
    func loadCurrentWeather(){
        temperatureLabel.text = currentWeather.temperature.temperatureStyled
        descriptionLabel.text = currentWeather.description.firstLetterCapitalized
        perceivedTemperatureLabel.text = "Ощущается \(currentWeather.perceivedTemperature) °C"
        humidityLabel.text = "Влажность \(currentWeather.humidity)% "
        temperatureLabel.sizeToFit()
    }
    
    func colorElements(){
        style = AppStyleController.currentStyle
        let color = style.color.withAlphaComponent(0.7)
        currentWeatherSubstrateView.backgroundColor = color
        dayWeatherSubstrateView.backgroundColor = color
        view.backgroundColor = color
        forecastTableView.backgroundColor = color
        
        navigationController!.navigationBar.barTintColor = seasonNavigationBarColor()
    }
    
    func setInterfaceStyle(){
        colorElements()
        backgroundImage.image = UIImage(named: "background_" + style.name)
    }
    
    func configureNavigationBar(){
        initNavigationItemTitleView()
    }
    
    private var forecastLoaded = false
    func loadForecast(){
        let rand = Int.random(in: 0..<forecast.daysCount)
        dayWeatherScrollView.configure(with: forecast[rand])
        forecastTableView.reloadData()
        forecastLoaded = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        configureNavigationBar()
        loadCurrentWeather()
        configureTableView()
        addRefreshControl()
        setInterfaceStyle()
        
        mainScrollView.delegate = self
        
        if forecast != nil{
            loadForecast()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StyleTableSegue"{
            let controller = segue.destination as! StyleTableViewController
            controller.delegate = self
        }
    }
    
    private func initNavigationItemTitleView() {
        let titleView = UILabel()
        titleView.text = city
        titleView.font = UIFont(name: "HelveticaNeue-Medium", size: 16)
        let width = titleView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
        titleView.frame = CGRect(origin:CGPoint.zero, size:CGSize(width: width, height: 500))
        self.navigationItem.titleView = titleView
        titleView.textColor = .white
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(titleWasTapped))
        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(recognizer)
    }
    
    @objc private func titleWasTapped() {
        performSegue(withIdentifier: "StyleTableSegue", sender: nil)
    }
    
    func addRefreshControl(){
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.clear
        refreshControl.backgroundColor = UIColor.clear
        kuranovSpinnerView = Bundle.main.loadNibNamed(ForecastViewIdentifiers.kuranovSpinnerView, owner: self, options: nil)?.first as! KuranovSpinnerView
        
        refreshControl.addSubview(kuranovSpinnerView)
        
        kuranovSpinnerView.frame = refreshControl.frame
        kuranovSpinnerView.backgroundColor = UIColor.clear
        mainScrollView.refreshControl = refreshControl
    }
    
    func performForecastRequest(){
        forecastLoaded = false
        let weatherRequest = WeatherRequest<Forecast>(url: ApiUrl.forecastUrl(for: city))
        weatherRequest.perform{[weak self] result in
            self?.kuranovSpinnerView.stopAnimation{[weak self] in
                self?.refreshControl.endRefreshing()
                self?.setForecastRequestResult(result: result)
            }
        }
        
        kuranovSpinnerView.startAnimation()
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
            city!.draw(with: strBounds, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        }
        return image
    }
    
    @IBAction func shareButtonAction(){
        let image = createShareImage()
        let url = image.save("share.jpeg")
        share(message: "Share", url: url)
    }
    
    func share(message: String, url: URL) {
        let objectsToShare = [message, url] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    deinit {
        print("deinit forecast")
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
            cell.configure(with: forecast[indexPath.row - 1, 3])
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
    }
}


extension ForecastViewController: StyleTableViewControllerDelegate{
    func styleChanged() {
        setInterfaceStyle()
    }
}

extension ForecastViewController: UIScrollViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < -150 {
            if  !kuranovSpinnerView.isAnimating {
                refreshControl.beginRefreshing()
                performForecastRequest()
            }
        }
    }
}
