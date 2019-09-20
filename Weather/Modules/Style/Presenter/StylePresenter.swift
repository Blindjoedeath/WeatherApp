//
//  StylePresenter.swift
//  Weather
//
//  Created by Blind Joe Death on 22/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol StylePresenterProtocol: class{
    
    var interactor: StyleInteractorProtocol! {get set}
    var router: StyleRouterProtocol! {get set}
    var view: StyleViewProtocol! {get set}
    
    func styleChanged(name: String)
    func load()
    func close()
}

class StylePresenter: StylePresenterProtocol{
    
    weak var view: StyleViewProtocol!
    var interactor: StyleInteractorProtocol!
    var router: StyleRouterProtocol!
    
    func styleChanged(name: String) {
        interactor.setStyle(name: name)
    }
    
    func load(){
        view.setItems(items: interactor.getAllStyles())
        interactor.configure()
    }
    
    func close(){
        router.close()
    }
    
    deinit {
        print("Deinited style presenter")
    }
}

extension StylePresenter: StyleInteractorOutput{
    func styleChanged(appStyle: AppStyle) {
        view.setStyle(style: appStyle)
    }
    
    
}
