//
//  ImageDownloaderTest.swift
//  NASA Picture of the DayTests
//
//  Created by Bo Han on 2/9/19.
//  Copyright © 2019 Bo Han. All rights reserved.
//

import XCTest

class ImageDownloaderTest: XCTestCase {
    var sut: ImageDownloader!
    var sessionMock = URLSessionMock()
    
    override func setUp() {
        sessionMock = URLSessionMock()
        sut = ImageDownloader(withURLSession: sessionMock)
    }

    func testImageDownloading() {
        let bundle = Bundle(for: type(of: self))
        guard let fileURL = bundle.url(forResource: "FakeImageData", withExtension: nil) else {
            return XCTFail()
        }
        
        do {
            sessionMock.data = try Data(contentsOf: fileURL)
        } catch {
            return XCTFail()
        }
        
        var closureExcuted = false
        sut.getImage(forURL: fileURL) { (data, error) in
            XCTAssertNil(error)
            if let data = data,
               let _ = UIImage(data: data)
            {
                XCTAssert(true)
            } else {
                XCTFail()
            }
            closureExcuted = true
        }
        
        XCTAssert(closureExcuted)
    }
    
    func testImageDownloadingWithError() {
        var closureExcuted = false
        sessionMock.error = ImageDownloaderError.responseError
        sut.getImage(forURL: URL(string: "google.com")!) { (data, error) in
            XCTAssertNil(data)
            switch error! {
            case .responseError: break
            case .invalidData: XCTFail()
            }
            closureExcuted = true
        }
        
        XCTAssert(closureExcuted)
    }
    
    func testImageDownloadingWithInvalidData() {
        var closureExcuted = false
        sut.getImage(forURL: URL(string: "google.com")!) { (data, error) in
            XCTAssertNil(data)
            switch error! {
            case .responseError: XCTFail()
            case .invalidData: break
            }
            closureExcuted = true
        }
        
        XCTAssert(closureExcuted)
    }
}
