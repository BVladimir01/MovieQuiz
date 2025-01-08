//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Vladimir on 08.01.2025.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }

    func testYesButton() throws {
        sleep(10)
        let firstPoster = app.images["Poster"]
        let firstImageData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap()
        sleep(5)
        let secondPoster = app.images["Poster"]
        let secondImageData = secondPoster.screenshot().pngRepresentation
        let secondIndex = app.staticTexts["Index"]
        XCTAssertNotEqual(firstImageData, secondImageData)
        XCTAssertEqual(secondIndex.label, "2/10")
    }

    func testNoButton() throws {
        sleep(10)
        let firstPoster = app.images["Poster"]
        let firstImageData = firstPoster.screenshot().pngRepresentation
        app.buttons["No"].tap()
        sleep(5)
        let secondPoster = app.images["Poster"]
        let secondImageData = secondPoster.screenshot().pngRepresentation
        let secondIndex = app.staticTexts["Index"]
        XCTAssertNotEqual(firstImageData, secondImageData)
        XCTAssertEqual(secondIndex.label, "2/10")
    }
    
    func testAlert() throws {
        for _ in 0..<10 {
            sleep(10)
            app.buttons["Yes"].tap()
        }
        sleep(2)
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть еще раз")
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
    }
}
