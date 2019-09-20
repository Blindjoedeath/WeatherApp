//
//  StyleRouter.swift
//  Weather
//
//  Created by Blind Joe Death on 22/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol StyleRouterProtocol{
    
    var presenter: StylePresenterProtocol! {get set}
    
    func close()
}

class StyleRouter: NSObject, StyleRouterProtocol{
    
    lazy var view: StyleTableViewController! = {
        return presenter.view as! StyleTableViewController
    }()
    weak var presenter: StylePresenterProtocol!
    
    func close(){
        view.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        //print("Style router deinited")
    }
}
