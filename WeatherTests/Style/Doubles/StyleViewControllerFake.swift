//
//  StyleViewControllerFake.swift
//  WeatherTests
//
//  Created by Blind Joe Death on 21/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather

class StyleViewControllerFake: StyleViewProtocol{
    var presenter: StylePresenterProtocol! {
        set {
        }
        get {
            return nil
        }
    }
    func setStyle(style: AppStyle) {
    }
    func setItems(items: [AppStyle]) {
    }
}
