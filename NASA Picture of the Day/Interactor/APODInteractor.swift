//
//  APODInteractor.swift
//  NASA Picture of the Day
//
//  Created by Bo Han on 2/9/19.
//  Copyright © 2019 Bo Han. All rights reserved.
//

import Foundation

enum APODError: Error {
    case invalidData
    case responseError
    case invalidURL
}

class APODInteractor {
    private enum RequestProperty {
        static let endpoint = "https://api.nasa.gov/planetary/apod"
        static let apiKey = "6uI0gJvUHu5lpcKIuLnp8DNL3JvkW0vZXx3liZMc"
    }
    
    private lazy var endPointWithApiKey: String = { return "\(RequestProperty.endpoint)?api_key=\(RequestProperty.apiKey)" }()
    private let urlSession: URLSession
    
    init(withURLSession urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    public func getAPOD(completion: @escaping (APOD?, APODError?) -> Void) {
        guard let url = URL(string: endPointWithApiKey) else { return completion(nil, .invalidURL) }
        
        urlSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return completion(nil, .responseError)
            }
            
            if let data = data {
                do {
                    let apodData = try JSONDecoder().decode(APOD.self, from: data)
                    completion(apodData, nil)
                } catch {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .invalidData)
            }
        }.resume()
    }
}
