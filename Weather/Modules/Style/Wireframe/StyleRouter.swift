//
//  StyleRouter.swift
//  Weather
//
//  Created by Blind Joe Death on 22/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class StyleRouter: NSObject{
    weak var view: StyleTableViewController!
    weak var presenter: StylePresenter!
    
    func close(){
        view.dismiss(animated: true, completion: nil)
        presenter.delegate = nil
    }
    
    static func build(from view: StyleTableViewController) -> StyleRouter{
        let router = StyleRouter()
        let interactor = StyleInteractor()
        let presenter = StylePresenter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        router.presenter = presenter
        router.view = view
        
        print(router)
        return router
    }
    
    deinit {
        print("Style router deinited")
    }
}
