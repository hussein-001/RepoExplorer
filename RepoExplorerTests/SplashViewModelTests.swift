//
//  SplashViewModelTests.swift
//  RepoExplorerTests
//
//  Created by Hussien Awada on 29/09/2025.
//

import XCTest
import Combine
@testable import RepoExplorer

class SplashViewModelTests: XCTestCase {
    var viewModel: SplashViewModel!
    var coordinator: AppCoordinator!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        coordinator = AppCoordinator()
        viewModel = SplashViewModel(coordinator: coordinator)
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        coordinator = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(viewModel.isLoading)
        XCTAssertEqual(coordinator.currentState, .splash)
    }
    
    func testSplashTimer() {
        let expectation = XCTestExpectation(description: "Splash timer completes")
        
        coordinator.$currentState
            .dropFirst() // Skip initial value
            .sink { state in
                if state == .main {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 4.0)
        
        XCTAssertEqual(coordinator.currentState, .main)
        XCTAssertFalse(viewModel.isLoading)
    }
}
