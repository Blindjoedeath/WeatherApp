//
//  StyleInteractor.swift
//  Weather
//
//  Created by Blind Joe Death on 22/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol StyleInteractorProtocol: class {
    
    var presenter: StyleInteractorOutput! {get set}
    
    func getStyle() -> AppStyle
    func setStyle(name: String)
    func getAllStyles() -> [AppStyle]
}

protocol StyleInteractorOutput: class{
    
}

class StyleInteractor: StyleInteractorProtocol {
    
    weak var presenter: StyleInteractorOutput!
    
    var styleRepository = AppStyleRepository.instance
    
    func getStyle() -> AppStyle {
        return styleRepository.appStyle.value
    }
    
    func setStyle(name: String) {
        let style = styleRepository.appStyles[name]!
        styleRepository.appStyle.accept(style)
    }
    
    func getAllStyles() -> [AppStyle] {
        return styleRepository.appStyles.map{ $0.value }
    }
    
    deinit {
        //print("Deinited style interactor")
    }
}
