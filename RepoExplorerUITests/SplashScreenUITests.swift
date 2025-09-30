//
//  SplashScreenUITests.swift
//  RepoExplorerUITests
//
//  Created by Hussien Awada on 29/09/2025.
//

import XCTest

final class SplashScreenUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testSplashScreenElements() throws {
        // Test that splash screen elements are visible
        XCTAssertTrue(app.staticTexts["RepoExplorer"].exists)
        XCTAssertTrue(app.staticTexts["Discover Google's GitHub Repositories"].exists)
        XCTAssertTrue(app.images["magnifyingglass.circle.fill"].exists)
    }
    
    func testSplashScreenNavigation() throws {
        // Wait for splash screen to appear
        let splashTitle = app.staticTexts["RepoExplorer"]
        XCTAssertTrue(splashTitle.waitForExistence(timeout: 1.0))
        
        // Wait for navigation to main screen (should happen after 3 seconds)
        let repositoryTitle = app.staticTexts["Repository List"]
        XCTAssertTrue(repositoryTitle.waitForExistence(timeout: 5.0))
        
        // Verify we're on the main screen
        XCTAssertTrue(app.staticTexts["This will be the main screen showing Google's repositories"].exists)
    }
}
