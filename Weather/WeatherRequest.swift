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
                escape(success)
            }
            
            if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let jsonData = data,
                let jsonDictionary = self.parse(json: jsonData) {
    
                var weather = self.parse(dictionary: jsonDictionary)
                success = true
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
