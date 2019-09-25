//
//  TestService.swift
//  Weather
//
//  Created by Blind Joe Death on 18/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class TestService{
    
    static var isTesting: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    static var isUITesting: Bool {
        return ProcessInfo.processInfo.arguments.contains("uiTests")
    }
}
