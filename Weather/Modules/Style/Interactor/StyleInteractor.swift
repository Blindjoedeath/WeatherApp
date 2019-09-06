//
//  StyleInteractor.swift
//  Weather
//
//  Created by Blind Joe Death on 22/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol StyleInteractorProtocol: class {
    func getStyle() -> AppStyleModel
    func setStyle(name: String)
    func getAllStyles() -> [AppStyleModel]
}

class StyleInteractor: StyleInteractorProtocol {
    
    var styleRepository = AppStyleRepository.instance
    
    func styleToModel(style: AppStyle) -> AppStyleModel{
        return AppStyleModel(name: style.name,
                             description: style.description,
                             color: style.color)
    }
    
    func getStyle() -> AppStyleModel {
        return styleToModel(style: styleRepository.appStyle.value)
    }
    
    func setStyle(name: String) {
        let style = styleRepository.appStyles[name]!
        styleRepository.appStyle.accept(style)
    }
    
    func getAllStyles() -> [AppStyleModel] {
        return styleRepository.appStyles.map{styleToModel(style: $0.value)}
    }
    
    deinit {
        //print("Deinited style interactor")
    }
}
