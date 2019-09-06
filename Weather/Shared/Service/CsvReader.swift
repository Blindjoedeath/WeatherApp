//
//  CsvReader.swift
//  Weather
//
//  Created by Oskar on 04/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

class CsvReader {
    
    private static func readData(from file:String, withType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: file, ofType: withType)
            else {
                return nil
        }
        do {
            let contents = try String(contentsOfFile: filepath, encoding: .windowsCP1251)
            return cleanRows(file: contents)
        } catch {
            return nil
        }
    }
    
    private static func cleanRows (file: String) -> String {
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\"", with: "")
        cleanFile = cleanFile.replacingOccurrences(of: "\"", with: "")
        return cleanFile
    }
    
    private static func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ";")
            result.append(columns)
        }
        return result
    }
    
    static func read(file: String) -> [[String]]?{
        let data = readData(from: file, withType: "csv")
        if let data = data{
            return csv(data: data)
        }
        return nil
    }
}

