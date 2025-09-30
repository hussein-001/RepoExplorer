//
//  RepositoryDetailUITests.swift
//  RepoExplorerUITests
//
//  Created by Hussien Awada on 29/09/2025.
//

import XCTest

final class RepositoryDetailUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testRepositoryDetailNavigation() throws {
        // Wait for repository list screen
        let repositoryTitle = app.staticTexts["Repositories"]
        XCTAssertTrue(repositoryTitle.waitForExistence(timeout: 5.0))
        
        // Wait for repositories to load
        let firstRepository = app.staticTexts.matching(identifier: "Repository Name").firstMatch
        if firstRepository.waitForExistence(timeout: 10.0) {
            // Tap on the first repository
            firstRepository.tap()
            
            // Verify we're on the detail screen
            let detailTitle = app.staticTexts["Repository Details"]
            XCTAssertTrue(detailTitle.waitForExistence(timeout: 3.0))
        }
    }
    
    func testRepositoryDetailElements() throws {
        // Navigate to detail screen (assuming repositories are loaded)
        let repositoryTitle = app.staticTexts["Repositories"]
        XCTAssertTrue(repositoryTitle.waitForExistence(timeout: 5.0))
        
        let firstRepository = app.staticTexts.matching(identifier: "Repository Name").firstMatch
        if firstRepository.waitForExistence(timeout: 10.0) {
            firstRepository.tap()
            
            // Check for key elements in detail view
            let detailTitle = app.staticTexts["Repository Details"]
            XCTAssertTrue(detailTitle.waitForExistence(timeout: 3.0))
            
            // Check for Done button
            let doneButton = app.buttons["Done"]
            XCTAssertTrue(doneButton.exists)
            
            // Check for Statistics section
            let statisticsText = app.staticTexts["Statistics"]
            XCTAssertTrue(statisticsText.exists)
            
            // Check for Owner section
            let ownerText = app.staticTexts["Owner"]
            XCTAssertTrue(ownerText.exists)
        }
    }
    
    func testRepositoryDetailDismiss() throws {
        // Navigate to detail screen
        let repositoryTitle = app.staticTexts["Repositories"]
        XCTAssertTrue(repositoryTitle.waitForExistence(timeout: 5.0))
        
        let firstRepository = app.staticTexts.matching(identifier: "Repository Name").firstMatch
        if firstRepository.waitForExistence(timeout: 10.0) {
            firstRepository.tap()
            
            // Verify we're on detail screen
            let detailTitle = app.staticTexts["Repository Details"]
            XCTAssertTrue(detailTitle.waitForExistence(timeout: 3.0))
            
            // Tap Done button
            let doneButton = app.buttons["Done"]
            XCTAssertTrue(doneButton.exists)
            doneButton.tap()
            
            // Verify we're back to repository list
            XCTAssertTrue(repositoryTitle.waitForExistence(timeout: 3.0))
        }
    }
}
