//
//  ImageExtension.swift
//  Weather
//
//  Created by Blind Joe Death on 17/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func save(_ name: String) -> URL{
        let path: String = NSSearchPathForDirectoriesInDomains( .documentDirectory, .userDomainMask, true).first!
        let url = URL(fileURLWithPath: path).appendingPathComponent(name)
        try! self.jpegData(compressionQuality: 1)?.write(to: url)
        return url
    }
}
