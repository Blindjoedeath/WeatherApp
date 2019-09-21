//
//  StyleRouter.swift
//  Weather
//
//  Created by Blind Joe Death on 22/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol StyleRouterProtocol: class{
    
    var presenter: StylePresenterProtocol! {get set}
    
    func close()
}

class StyleRouter: NSObject, StyleRouterProtocol{
    
    weak var styleTableViewControllerCached: StyleTableViewController!
    weak var view: StyleTableViewController! {
        get{
            if styleTableViewControllerCached == nil{
                styleTableViewControllerCached = presenter.view as! StyleTableViewController
            }
            return styleTableViewControllerCached
        }
        set{
            styleTableViewControllerCached = newValue
        }
    }
    weak var presenter: StylePresenterProtocol!
    
    func close(){
        view.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("Style router deinited")
    }
}
