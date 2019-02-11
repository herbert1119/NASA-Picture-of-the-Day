//
//  ImageDownloader.swift
//  NASA Picture of the Day
//
//  Created by Bo Han on 2/9/19.
//  Copyright © 2019 Bo Han. All rights reserved.
//

import Foundation

enum ImageDownloaderError: Error {
    case invalidData
    case responseError
}

class ImageDownloader {
    private let urlSession: URLSession
    
    init(withURLSession urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func getImage(forURL url: URL, completion: @escaping (Data?, ImageDownloaderError?) -> Void) {
        self.urlSession.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return completion(nil, .responseError)
            }
            
            if let data = data {
                return completion(data, nil)
            } else {
                return completion(nil, .invalidData)
            }
        }.resume()
    }
}
