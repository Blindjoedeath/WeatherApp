//
//  Search.swift
//  Weather
//
//  Created by Blind Joe Death on 01/11/2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import Foundation
import UIKit

class WeatherRequest{
    
    private var task: URLSessionDataTask? = nil

    typealias RequestCompleted = (Bool) -> Void
    
    enum State {
        case notRequestedYet
        case loading
        case noResult
        // case wrongCity
        case result(Weather)
    }
    
    private(set) var state: State = .notRequestedYet
    
    func weatherUrl(for city: String) -> URL{
        let urlString = String(format:
            "http://api.openweathermap.org/data/2.5/weather?q=%@&APPID=%@", city, weatherApiToken)
        return URL(string: urlString)!
    }
    
    func cancel(){
        task?.cancel()
    }
    
    func perform(for city: String, completion: @escaping RequestCompleted) {
        task?.cancel()
        state = .loading
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = weatherUrl(for: city)
        let session = URLSession.shared
        task = session.dataTask(with: url, completionHandler: {
            data, response, error in
            
            let escape = {(_ success: Bool) in
                DispatchQueue.main.async{
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    completion(success)
                }
            }
            var success = false
            if let error = error as NSError?, error.code == -999 {
                self.state = .noResult
                escape(success)
            }
            
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 200 {
                    if let jsonData = data,
                        let jsonDictionary = self.parse(json: jsonData) {
                        self.state = .result(self.parse(dictionary: jsonDictionary))
                        success = true
                    }
                } else {
                    print(httpResponse.statusCode)
                    self.state = .noResult
                }
            }
            
            escape(success)
        })
        task?.resume()
    }
    
    private func parse(json data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
    
    private func parse(dictionary: [String: Any]) -> Weather {
        let weather = Weather()
        return weather
    }
}
