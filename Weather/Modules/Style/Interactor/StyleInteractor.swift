//
//  StyleInteractor.swift
//  Weather
//
//  Created by Blind Joe Death on 22/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol StyleInteractorProtocol: class {
    func getStyle() -> AppStyle
    func setStyle(name: String)
    func getAllStyles() -> [AppStyle]
}

class StyleInteractor: StyleInteractorProtocol {
    
    var styleRepository = AppStyleRepository.instance
    
    func styleToModel(style: AppStyle) -> AppStyle{
        return AppStyle(name: style.name,
                        description: style.description,
                        color: style.color)
    }
    
    func getStyle() -> AppStyle {
        return styleToModel(style: styleRepository.appStyle.value)
    }
    
    func setStyle(name: String) {
        let style = appStyles[name]!
        styleRepository.appStyle.accept(style)
    }
    
    func getAllStyles() -> [AppStyle] {
        return appStyles.map{styleToModel(style: $0.value)}
    }
    
    deinit {
        //print("Deinited style interactor")
    }
}
