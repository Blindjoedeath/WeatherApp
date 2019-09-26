//
//  DayForecastConfigurator.swift
//  Weather
//
//  Created by Oskar on 09/07/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class DayForecastConfigurator: NSObject {
    
    var view: DayForecastViewProtocol!
    
    lazy var router: DayForecastRouterProtocol! = DayForecastRouter()
    lazy var presenter: DayForecastPresenterProtocol! = DayForecastPresenter()
    lazy var interactor: DayForecastInteractorProtocol! = DayForecastInteractor()
    lazy var interactorOutput: DayForecastInteractorOutput! = {
        return self.presenter as? DayForecastInteractorOutput
    }()
    
    func mockDependencies(){
        let interactor = self.interactor as! DayForecastInteractor
        interactor.weatherRepository = WeatherRepositoryStub.stubInstance
    }
    
    func build() -> DayForecastRouterProtocol {
        presenter?.interactor = interactor
        presenter?.router = router
        presenter?.view = view
        
        view?.presenter = presenter
        
        interactor?.presenter = interactorOutput
        
        router?.presenter = presenter
        
        #if UITESTS
            mockDependencies()
        #endif
        
        return router!
    }
    
    func build(with view: DayForecastViewProtocol) -> DayForecastRouterProtocol{
        self.view = view
        return build()
    }
}
