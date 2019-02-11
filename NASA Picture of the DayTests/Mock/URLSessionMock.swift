//
//  URLSessionMock.swift
//  NASA Picture of the DayTests
//
//  Created by Bo Han on 2/9/19.
//  Copyright © 2019 Bo Han. All rights reserved.
//

import Foundation

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure:() -> Void
    
    init(closure: @escaping() -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}

class URLSessionMock: URLSession {
    var data: Data?
    var error: Error?
    var response: URLResponse?
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSessionDataTaskMock(closure: {
            completionHandler(self.data, self.response, self.error)
        })
    }
}
