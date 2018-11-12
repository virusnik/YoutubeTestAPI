//
//  NetworkService.swift
//  YoutubeTestAPI
//
//  Created by Sergio Veliz on 11/7/18.
//  Copyright © 2018 Sergio Veliz. All rights reserved.
//

import Foundation

class NetworkService {
    
    private init() {}
    static let shared = NetworkService()
    
    typealias JSONTask = URLSessionDataTask
    typealias JSONCompletionHandler = ([String: Any]?, HTTPURLResponse?, Error?) -> Void
    
    public func getData(url: URLRequest, completion: @escaping (Data) -> ()) {
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            DispatchQueue.main.sync {
                completion(data)
            }
            
            }.resume()
    }
    
}
