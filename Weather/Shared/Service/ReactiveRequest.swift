//
//  ReactiveRequest.swift
//  Weather
//
//  Created by Oskar on 06/09/2019.
//  Copyright © 2019 Codezavod. All rights reserved.
//

import Foundation
import RxSwift

enum ReactiveRequestError: Error{
    case badResponse(code: Int)
    case noResponce
}

class ReactiveRequest<T: Decodable>{
    
    static func create(for url: URL) -> Observable<T> {
        return Observable<T>.create{ observer in
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error{
                    observer.onError(error)
                } else if let httpResponse = response as? HTTPURLResponse{
                    
                    if httpResponse.statusCode == 200, let data = data{
                        do{
                            let data = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(data)
                            observer.onCompleted()
                        }
                        catch let e{
                            observer.onError(e)
                        }
                    } else {
                        let code = httpResponse.statusCode
                        let e = ReactiveRequestError.badResponse(code: code)
                        observer.onError(e)
                    }
                } else {
                    let e = ReactiveRequestError.noResponce
                    observer.onError(e)
                }
            }
            task.resume()
            
            return Disposables.create{
                task.cancel()
            }
        }
    }
}



