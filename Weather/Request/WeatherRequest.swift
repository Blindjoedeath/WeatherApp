//
//  RequestProtocol.swift
//  Weather
//
//  Created by Blind Joe Death on 09/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import UIKit

class WeatherRequest<Result> where Result: Codable {
    
    private var task: URLSessionDataTask? = nil
    private var url: URL
    
    init(url u: URL) {
        url = u
    }
    
    func cancel(){
        task?.cancel()
    }
    
    func perform(completion: @escaping (Result?) -> Void) {
        task?.cancel()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let session = URLSession.shared
        task = session.dataTask(with: url, completionHandler: {
            data, response, error in
            
            var result: Result?
            if let error = error as NSError?, error.code == -999 {
                result = nil
            } else if let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let jsonData = data {
                
                result = self.parse(json: jsonData)
            }
            
            DispatchQueue.main.async{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                completion(result)
            }
        })
        task?.resume()
    }
    
    private func parse(json data: Data) -> Result? {
        return try? JSONDecoder().decode(Result.self, from: data)
    }
}
