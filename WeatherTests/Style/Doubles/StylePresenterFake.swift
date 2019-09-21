//
//  StylePresenterFake.swift
//  WeatherTests
//
//  Created by Oskar on 20/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
@testable import Weather


class StylePresenterFake: StylePresenterProtocol{
    var interactor: StyleInteractorProtocol! {
        set {
        }
        get {
            return nil
        }
    }
    var router: StyleRouterProtocol! {
        set {
        }
        get {
            return nil
        }
    }
    var view: StyleViewProtocol! {
        set {
        }
        get {
            return nil
        }
    }
    func styleChanged(name: String) {
    }
    func load() {
    }
    func close() {
    }
}
