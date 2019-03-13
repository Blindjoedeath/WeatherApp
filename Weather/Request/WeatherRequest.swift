//
//  RequestProtocol.swift
//  Weather
//
//  Created by Blind Joe Death on 09/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import UIKit


enum RequestResult<T> {
    case noNetwork
    case noLocation
    case result(T)
}

class WeatherRequest<T> where T: Codable {
    
    private var task: URLSessionDataTask? = nil
    private var url: URL
    
    init(url u: URL) {
        url = u
    }
    
    func cancel(){
        task?.cancel()
    }
    
    func perform(completion: @escaping (RequestResult<T>) -> Void) {
        task?.cancel()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let session = URLSession.shared
        task = session.dataTask(with: url, completionHandler: {
            data, response, error in
            
            var result: RequestResult<T>
            if let error = error as NSError?, error.code == -999 {
                result = .noNetwork
            } else if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 200{
                    result = .result(self.parse(json: data!))
                } else {
                    result = .noLocation
                }
            } else {
                result = .noNetwork
            }
            
            DispatchQueue.main.async{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                completion(result)
            }
        })
        task?.resume()
    }
    
    private func parse(json data: Data) -> T {
        return try! JSONDecoder().decode(T.self, from: data)
    }
}
