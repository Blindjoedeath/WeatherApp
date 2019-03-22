//
//  RequestProtocol.swift
//  Weather
//
//  Created by Blind Joe Death on 09/03/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation

enum RequestResult<T> {
    case noNetwork
    case noLocation
    case timeOut
    case result(T)
}

class WeatherRequest<T> where T: Codable {
    
    var timeLimit: Int = 20
    
    private var timer: Timer!
    private var task: URLSessionDataTask? = nil
    private var url: URL
    private var result: RequestResult<T>!
    private var completion: ((RequestResult<T>) -> Void)!
    
    init(url: URL) {
        self.url = url
    }
    
    func cancel(){
        task?.cancel()
        timer?.invalidate()
    }
    
    @objc
    private func taskTimeOut(){
        cancel()
        result = .timeOut
        completion(result)
    }
    
    func perform(completion: @escaping (RequestResult<T>) -> Void) {
        cancel()
        result = nil
        self.completion = completion
        
        let session = URLSession.shared
        task = session.dataTask(with: url, completionHandler: {
            data, response, error in
            
            self.timer?.invalidate()
            
            if let error = error as NSError?, error.code == -999 {
                self.result = .noNetwork
            } else if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 200{
                    self.result = .result(self.parse(json: data!))
                } else {
                    self.result = .noLocation
                }
            } else {
                self.result = .noNetwork
            }
            
            DispatchQueue.main.async{
                completion(self.result)
            }
        })
        task?.resume()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(timeLimit),
                                     target: self,
                                     selector: #selector(taskTimeOut),
                                     userInfo: nil, repeats: false)
    }
    
    private func parse(json data: Data) -> T {
        return try! JSONDecoder().decode(T.self, from: data)
    }
}
