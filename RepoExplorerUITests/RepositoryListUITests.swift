//
//  RepositoryListUITests.swift
//  RepoExplorerUITests
//
//  Created by Hussien Awada on 29/09/2025.
//

import XCTest

final class RepositoryListUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testRepositoryListScreenElements() throws {
        // Wait for splash screen to complete and navigate to repository list
        let repositoryTitle = app.staticTexts["Repositories"]
        XCTAssertTrue(repositoryTitle.waitForExistence(timeout: 5.0))
        
        // Test search bar elements
        let searchField = app.searchFields["Search repositories..."]
        XCTAssertTrue(searchField.exists)
        
        // Test navigation title
        XCTAssertTrue(app.navigationBars["Repositories"].exists)
    }
    
    func testSearchFunctionality() throws {
        // Wait for repository list screen
        let repositoryTitle = app.staticTexts["Repositories"]
        XCTAssertTrue(repositoryTitle.waitForExistence(timeout: 5.0))
        
        // Find and tap search field
        let searchField = app.searchFields["Search repositories..."]
        XCTAssertTrue(searchField.exists)
        searchField.tap()
        
        // Type in search field
        searchField.typeText("swift")
        
        // Wait for search results (this will depend on actual API response)
        // For now, just verify the text was entered
        XCTAssertEqual(searchField.value as? String, "swift")
    }
    
    func testClearSearchButton() throws {
        // Wait for repository list screen
        let repositoryTitle = app.staticTexts["Repositories"]
        XCTAssertTrue(repositoryTitle.waitForExistence(timeout: 5.0))
        
        // Enter search text
        let searchField = app.searchFields["Search repositories..."]
        searchField.tap()
        searchField.typeText("test")
        
        // Look for clear button (X button)
        let clearButton = app.buttons["xmark.circle.fill"]
        if clearButton.exists {
            clearButton.tap()
            XCTAssertEqual(searchField.value as? String, "")
        }
    }
    
    func testPullToRefresh() throws {
        // Wait for repository list screen
        let repositoryTitle = app.staticTexts["Repositories"]
        XCTAssertTrue(repositoryTitle.waitForExistence(timeout: 5.0))
        
        // Find the list and perform pull to refresh
        let list = app.tables.firstMatch
        if list.exists {
            let start = list.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
            let end = list.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
            start.press(forDuration: 0.1, thenDragTo: end)
        }
    }
}
