//
//  NASA_Picture_of_the_DayUITests.swift
//  NASA Picture of the DayUITests
//
//  Created by Bo Han on 2/9/19.
//  Copyright © 2019 Bo Han. All rights reserved.
//

import XCTest

class NASA_Picture_of_the_DayUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    func testNavigationBetweenViewControllers() {
        var tapable = verifyShowingMainViewController()
        tapable.tap()
        tapable = verifyShowingHDImageViewController()
        tapable.tap()
        _ = verifyShowingMainViewController()
    }
    
    private func verifyShowingMainViewController() -> XCUIElement {
        let app = XCUIApplication()
        let image = app.images["Image"]
        let imageExists = image.waitForExistence(timeout: 60)
        XCTAssert(imageExists)
        
        let label = app.staticTexts["Title"]
        let labelExists = label.waitForExistence(timeout: 0.1)
        XCTAssert(labelExists)
        return image
    }
    
    private func verifyShowingHDImageViewController() -> XCUIElement {
        let app = XCUIApplication()
        let hdImage = app.images["HDImage"]
        let hdImageExists = hdImage.waitForExistence(timeout: 1)
        XCTAssert(hdImageExists)
        return hdImage
    }

}
