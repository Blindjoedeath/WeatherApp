//
//  WeatherAssembly.swift
//  Weather
//
//  Created by Oskar on 09/07/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class WeatherConfigurator{
    
    var view: WeatherViewProtocol!
    
    lazy var router: WeatherRouterProtocol! = WeatherRouter()
    lazy var presenter: WeatherPresenterProtocol! = WeatherPresenter()
    lazy var interactor: WeatherInteractorProtocol! = WeatherInteractor()
    lazy var interactorOutput: WeatherInteractorOutput! = {
        return self.presenter as? WeatherInteractorOutput
    }()
    
    func build() -> WeatherRouterProtocol {
        presenter?.interactor = interactor
        presenter?.router = router
        presenter?.view = view
        
        view?.presenter = presenter
        
        interactor?.presenter = interactorOutput
        
        router?.presenter = presenter
        
        return router!
    }
    
    func build(with view: WeatherViewProtocol) -> WeatherRouterProtocol{
        self.view = view
        return build()
    }
}
