//
//  TestView.swift
//  WeatherTests
//
//  Created by Oskar on 11/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import UIKit

class StoryboardView<T: UIViewController>{
    func instantiate(withIdentifier: String) -> T{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: withIdentifier) as! T
        return controller
    }
}
