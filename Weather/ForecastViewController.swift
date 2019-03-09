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
    
    func loadBackground(){
        let now = Date()
        let season = now.season()
        let image = UIImage(named: season)
        backgroundImage.image = image
        
        print("here")
    }
    
    func configureNavigationBar(){
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        
        loadBackground()
    }
}
