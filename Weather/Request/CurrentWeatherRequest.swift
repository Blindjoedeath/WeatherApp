//
//  Search.swift
//  Weather
//
//  Created by Blind Joe Death on 01/11/2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import Foundation
import UIKit

class CurrentWeatherRequest{
    
    private var task: URLSessionDataTask? = nil
    
    func weatherUrl(for city: String) -> URL{
        let urlString = String(format:
            "http://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@", city, weatherApiToken)
        return URL(string: urlString)!
    }
    
    func cancel(){
        task?.cancel()
    }
    
    func perform(for city: String, completion: @escaping (Weather?) -> Void) {
        task?.cancel()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = weatherUrl(for: city)
        let session = URLSession.shared
        task = session.dataTask(with: url, completionHandler: {
            data, response, error in
            
            var weather: Weather?
            if let error = error as NSError?, error.code == -999 {
                weather = nil
            } else if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let jsonData = data {
                
                weather = self.parse(json: jsonData)
            }
            
            DispatchQueue.main.async{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                completion(weather)
            }
        })
        task?.resume()
    }
    
    private func parse(json data: Data) -> Weather? {
        return try? JSONDecoder().decode(Weather.self, from: data)
    }
}
