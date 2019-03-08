//
//  HistoricalWeatherRequest.swift
//  Weather
//
//  Created by Blind Joe Death on 22/11/2018.
//  Copyright © 2018 Codezavod. All rights reserved.
//

import Foundation
import UIKit

class ForecastWeatherRequest{
    
    private var task: URLSessionDataTask? = nil
    
    func forecastWeatherUrl(for city: String) -> URL{
        var urlString = String(format:
            "https://samples.openweathermap.org/data/2.5/forecast?q=%@&appid=%@", city, weatherApiToken)
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return URL(string: urlString)!
    }
    
    func cancel(){
        task?.cancel()
    }
    
    func perform(for city: String, completion: @escaping (Forecast?) -> Void) {
        task?.cancel()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = forecastWeatherUrl(for: city)
        let session = URLSession.shared
        task = session.dataTask(with: url, completionHandler: {
            data, response, error in
            
            var forecast: Forecast?
            if let error = error as NSError?, error.code == -999 {
                forecast = nil
            } else if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let jsonData = data {
                
                forecast = self.parse(json: jsonData)
            }
            
            DispatchQueue.main.async{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                completion(forecast)
            }
        })
        task?.resume()
    }
    
    private func parse(json data: Data) -> Forecast? {
        return try? JSONDecoder().decode(Forecast.self, from: data)
    }
}
