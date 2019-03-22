//
//  File.swift
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
