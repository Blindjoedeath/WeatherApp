//
//  StringExtension.swift
//  Weather
//
//  Created by Blind Joe Death on 10/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

extension String {
    var firstLetterCapitalized : String {
        get{
            return self.prefix(1).uppercased() + self.lowercased().dropFirst()
        }
    }
}
