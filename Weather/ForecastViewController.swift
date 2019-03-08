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
    
    func loadBackground(){
        let now = Date()
        let season = now.season()
        let image = UIImage(named: season)
        backgroundImage.image = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadBackground()
    }
}
