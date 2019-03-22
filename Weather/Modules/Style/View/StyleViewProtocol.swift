//
//  StyleViewProtocol.swift
//  Weather
//
//  Created by Blind Joe Death on 22/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

protocol StyleViewProtocol: class {
    func setStyle(style: AppStyleModel)
    func setItems(items: [AppStyleModel])
}
