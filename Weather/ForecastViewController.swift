//
//  ForecastViewController.swift
//  Weather
//
//  Created by Blind Joe Death on 09/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    
    public var city: String!
    
    private var forecastVar : Forecast!
    public var forecast: Forecast! {
        set {
            if newValue != nil && forecast == nil{
                forecastVar = newValue
            }
        }
        get{
            return forecastVar
        }
    }
    
    public var currentWeather: Weather!
    
    func seasonImage(name: String) -> UIImage?{
        let now = Date()
        let season = now.season()
        return UIImage(named: name + "_" + season)
    }
    
    func loadBackground(){
        backgroundImage.image = seasonImage(name: "background")
    }
    
    func configureNavigationBar(){
        let navigationBar = navigationController!.navigationBar
        navigationBar.setBackgroundImage(seasonImage(name: "navbar"), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        loadBackground()
    }
}
