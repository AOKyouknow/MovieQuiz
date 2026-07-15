//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Алик on 07.07.2026.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()

    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
        
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testYesButton() throws {
        
        //sleep(3)
        let firstPoster = app.images["imageView"]
        //XCTAssertTrue(firstPoster.exists)
        let firstPosterData = firstPoster.screenshot().pngRepresentation// берём содержимое для последующего сравнения
        
        app.buttons["yesButton"].tap()
        //sleep(3)
        
        let secondPoster = app.images["imageView"]
        //XCTAssert(secondPoster.exists)
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    
    func testNoButton() throws {
        sleep(3)
        let firstPoster = app.images["imageView"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["noButton"].tap()
        sleep(3)
        
        let secondPoster = app.images["imageView"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        
        let counterLabel = app.staticTexts["counterLabel"].label
        XCTAssertEqual(counterLabel, "2/10")
    }
    
    func testAlert() throws {
        for _ in 1...10 {
            app.buttons["yesButton"].tap()
            sleep(1)
        }
        
        XCTAssertTrue(app.alerts["alertResult"].waitForExistence(timeout: 5))
        
        XCTAssertEqual(app.alerts["alertResult"].buttons["alertAction"].label, "Сыграть ещё раз!")
        
        XCTAssertEqual(app.alerts["alertResult"].label, "Этот раунд окончен!")
        
        
    }
    
    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Game results"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    } 
   
}//
