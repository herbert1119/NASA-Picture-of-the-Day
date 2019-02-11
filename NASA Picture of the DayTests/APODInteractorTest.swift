//
//  APODInteractorTest.swift
//  NASA Picture of the DayTests
//
//  Created by Bo Han on 2/9/19.
//  Copyright © 2019 Bo Han. All rights reserved.
//

import XCTest

class APODInteractorTest: XCTestCase {
    var sut: APODInteractor!
    var sessionMock = URLSessionMock()
    
    override func setUp() {
        sessionMock = URLSessionMock()
        sut = APODInteractor(withURLSession: sessionMock)
    }

    func testGetAPODData() {
        let bundle = Bundle(for: type(of: self))
        guard let fileURL = bundle.url(forResource: "APODFakeData", withExtension: nil) else {
            return XCTFail()
        }
        var closureExcuted = false
        do {
            sessionMock.data = try Data(contentsOf: fileURL)
            sut.getAPOD { (apod, error) in
                XCTAssertNil(error)
                XCTAssertEqual(apod?.hdurl, "https://apod.nasa.gov/apod/image/1902/Iwamoto-104-2019griffin.jpg")
                XCTAssertEqual(apod?.url, "https://apod.nasa.gov/apod/image/1902/Iwamoto-104-2019griffin_1024.jpg")
                XCTAssertEqual(apod?.title, "Comet Iwamoto and the Sombrero Galaxy")
                closureExcuted = true
            }
        } catch {
            return XCTFail()
        }
        XCTAssert(closureExcuted)
    }
    
    func testGetAPODDataWithError() {
        sessionMock.error = APODError.responseError
        var closureExcuted = false
        sut.getAPOD { (apod, error) in
            XCTAssertNil(apod)
            switch error! {
            case .invalidData: XCTFail()
            case .responseError: break
            case .invalidURL: XCTFail()
            }
            closureExcuted = true
        }
        
        XCTAssert(closureExcuted)
    }
    
    func testGetAPODDataInvalidJson() {
        var closureExcuted = false
        sessionMock.data = "wrong data".data(using: .utf8)
        sut.getAPOD { (apod, error) in
            XCTAssertNil(apod)
            switch error! {
            case .invalidData: break
            case .responseError: XCTFail()
            case .invalidURL: XCTFail()
            }
            closureExcuted = true
        }
        XCTAssert(closureExcuted)
    }
    
    func testGetAPODDataInvalidData() {
        var closureExcuted = false
        sut.getAPOD { (apod, error) in
            XCTAssertNil(apod)
            switch error! {
            case .invalidData: break
            case .responseError: XCTFail()
            case .invalidURL: XCTFail()
            }
            closureExcuted = true
        }
        XCTAssert(closureExcuted)
    }
}
