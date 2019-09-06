//
//  StylePresenter.swift
//  Weather
//
//  Created by Blind Joe Death on 22/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol StylePresenterProtocol: class{
    func styleChanged(name: String)
    func configureView()
    func close()
}

class StylePresenter: StylePresenterProtocol{
    
    weak var view: StyleViewProtocol!
    var interactor: StyleInteractorProtocol!
    var router: StyleRouter!
    
    var seasons = ["winter", "spring", "summer", "autumn"]
    
    func styleChanged(name: String) {
        interactor.setStyle(name: name)
        view.setStyle(style: interactor.getStyle())
    }
    
    func configureView(){
        view.setStyle(style: interactor.getStyle())
        view.setItems(items: interactor.getAllStyles())
    }
    
    func close(){
        router.close()
    }
    
    deinit {
        //print("Deinited style presenter")
    }
}
