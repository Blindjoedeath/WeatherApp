//
//  StyleRouterConfigurator.swift
//  Weather
//
//  Created by Oskar on 09/07/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class StyleConfigurator: NSObject {
    
    var view: StyleViewProtocol!
    
    lazy var router: StyleRouterProtocol! = StyleRouter()
    lazy var presenter: StylePresenterProtocol! = StylePresenter()
    lazy var interactor: StyleInteractorProtocol! = StyleInteractor()
    lazy var interactorOutput: StyleInteractorOutput! = {
        return self.presenter as? StyleInteractorOutput
    }()
    
    func build() -> StyleRouterProtocol {
        presenter?.interactor = interactor
        presenter?.router = router
        presenter?.view = view
        
        view?.presenter = presenter
        
        interactor?.presenter = interactorOutput
        
        router?.presenter = presenter
        
        return router!
    }
    
    func build(with view: StyleViewProtocol) -> StyleRouterProtocol{
        self.view = view
        return build()
    }
}
