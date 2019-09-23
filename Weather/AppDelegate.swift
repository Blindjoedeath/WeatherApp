//
//  AppDelegate.swift
//  Weather
//
//  Created by Blind Joe Death on 01/11/2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var router: LocationRouterProtocol!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        
        let view = window?.rootViewController as! LocationViewController
        router = LocationConfigurator().build(with: view)
        return true
    }
}

