//
//  StyleRouter.swift
//  Weather
//
//  Created by Blind Joe Death on 22/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol StyleRouterProtocol{
    func close()
}

class StyleRouter: NSObject, StyleRouterProtocol{
    weak var view: StyleTableViewController!
    weak var presenter: StylePresenter!
    
    func close(){
        view.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("Style router deinited")
    }
}
