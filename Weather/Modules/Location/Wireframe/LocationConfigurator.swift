//
//  LocationAssembly.swift
//  Weather
//
//  Created by Blind Joe Death on 21/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class LocationConfigurator: NSObject {
    
    var view: LocationViewProtocol!
    
    lazy var router: LocationRouterProtocol! = LocationRouter()
    lazy var presenter: LocationPresenterProtocol! = LocationPresenter()
    lazy var interactor: LocationInteractorProtocol! = LocationInteractor()
    lazy var interactorOutput: LocationInteractorOutput! = {
        return self.presenter as? LocationInteractorOutput
    }()
    
    func mockDependencies(){
        let interactor = self.interactor as! LocationInteractor
        let cityRepository = CityRepositoryStub.instance
        cityRepository.stubbedCity.accept("")
        interactor.cityRepository = cityRepository
        let geolocationService = GeolocationServiceStub.instance
        geolocationService.stubbedLocality = "Stubbed city"
        interactor.geolocationService = geolocationService
        interactor.weatherRepository = WeatherRepositoryStub.stubInstance
    }
    
    func build() -> LocationRouterProtocol {
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
    
    func build(with view: LocationViewProtocol) -> LocationRouterProtocol{
        self.view = view
        return build()
    }
}
