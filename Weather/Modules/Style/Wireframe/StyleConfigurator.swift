//
//  StyleRouterConfigurator.swift
//  Weather
//
//  Created by Oskar on 09/07/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class StyleConfigurator{
    
    static func build(from view: StyleTableViewController) -> StyleRouter{
        let router = StyleRouter()
        let interactor = StyleInteractor()
        let presenter = StylePresenter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        router.presenter = presenter
        router.view = view
        
        print(router)
        return router
    }
}
