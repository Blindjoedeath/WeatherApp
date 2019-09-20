//
//  StyleInteractor.swift
//  Weather
//
//  Created by Blind Joe Death on 22/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import RxSwift

protocol StyleInteractorProtocol: class {
    
    var presenter: StyleInteractorOutput! {get set}
    
    func setStyle(name: String)
    func getAllStyles() -> [AppStyle]
    func configure()
}

protocol StyleInteractorOutput: class{
    func styleChanged(appStyle: AppStyle)
}

class StyleInteractor: StyleInteractorProtocol {
    
    weak var presenter: StyleInteractorOutput!
    
    var styleRepository = AppStyleRepository.instance
    var bag = DisposeBag()
    
    func configure(){
        styleRepository.appStyle
            .subscribe(onNext: {style in
                self.presenter.styleChanged(appStyle: style)
            }).disposed(by: bag)
    }
    
    func setStyle(name: String) {
        let style = styleRepository.appStyles[name]!
        styleRepository.appStyle.accept(style)
    }
    
    func getAllStyles() -> [AppStyle] {
        return styleRepository.appStyles.map{ $0.value }
    }
    
    deinit {
        print("Deinited style interactor")
    }
}
