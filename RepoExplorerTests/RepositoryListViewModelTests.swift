//
//  RepositoryListViewModelTests.swift
//  RepoExplorerTests
//
//  Created by Hussien Awada on 29/09/2025.
//

import XCTest
import Combine
@testable import RepoExplorer

@MainActor
class RepositoryListViewModelTests: XCTestCase {
    var viewModel: RepositoryListViewModel!
    var mockSearchUseCase: MockSearchRepositoriesUseCase!
    var mockGetGoogleRepositoriesUseCase: MockGetGoogleRepositoriesUseCase!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockSearchUseCase = MockSearchRepositoriesUseCase()
        mockGetGoogleRepositoriesUseCase = MockGetGoogleRepositoriesUseCase()
        cancellables = Set<AnyCancellable>()
        
        viewModel = RepositoryListViewModel(
            searchUseCase: mockSearchUseCase,
            getGoogleRepositoriesUseCase: mockGetGoogleRepositoriesUseCase
        )
    }
    
    override func tearDown() {
        cancellables = nil
        viewModel = nil
        mockSearchUseCase = nil
        mockGetGoogleRepositoriesUseCase = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.repositories.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showingError)
        XCTAssertEqual(viewModel.searchText, "")
    }
    
    func testSearchTextChanges() {
        let expectation = XCTestExpectation(description: "Search text changes")
        
        viewModel.$searchText
            .dropFirst() // Skip initial value
            .sink { searchText in
                XCTAssertEqual(searchText, "test")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.searchText = "test"
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testClearSearch() {
        viewModel.searchText = "test search"
        viewModel.clearSearch()
        
        XCTAssertEqual(viewModel.searchText, "")
    }
    
    func testLoadInitialRepositoriesSuccess() {
        let mockRepositories = createMockRepositories()
        mockGetGoogleRepositoriesUseCase.mockRepositories = mockRepositories
        
        let expectation = XCTestExpectation(description: "Load initial repositories")
        
        viewModel.$repositories
            .dropFirst() // Skip initial empty array
            .sink { repositories in
                XCTAssertEqual(repositories.count, 2)
                XCTAssertEqual(repositories.first?.name, "Test Repo 1")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.loadInitialRepositories()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSearchRepositoriesSuccess() {
        let mockResponse = SearchRepositoriesResponse(
            totalCount: 1,
            items: createMockRepositories()
        )
        mockSearchUseCase.mockResponse = mockResponse
        
        let expectation = XCTestExpectation(description: "Search repositories")
        
        viewModel.$repositories
            .dropFirst() // Skip initial empty array
            .sink { repositories in
                XCTAssertEqual(repositories.count, 2)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.searchText = "test"
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testSearchRepositoriesError() {
        mockSearchUseCase.shouldFail = true
        mockSearchUseCase.mockError = GitHubAPIError.noData
        
        let expectation = XCTestExpectation(description: "Search repositories error")
        
        viewModel.$showingError
            .dropFirst() // Skip initial false
            .sink { showingError in
                XCTAssertTrue(showingError)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.searchText = "test"
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    private func createMockRepositories() -> [Repository] {
        return [
            Repository(
                id: 1,
                name: "Test Repo 1",
                fullName: "google/test-repo-1",
                description: "Test repository 1",
                htmlUrl: "https://github.com/google/test-repo-1",
                language: "Swift",
                stargazersCount: 100,
                forksCount: 50,
                createdAt: "2023-01-01T00:00:00Z",
                updatedAt: "2023-01-01T00:00:00Z",
                owner: RepositoryOwner(
                    id: 1,
                    login: "google",
                    avatarUrl: "https://github.com/google.png",
                    htmlUrl: "https://github.com/google"
                )
            ),
            Repository(
                id: 2,
                name: "Test Repo 2",
                fullName: "google/test-repo-2",
                description: "Test repository 2",
                htmlUrl: "https://github.com/google/test-repo-2",
                language: "Python",
                stargazersCount: 200,
                forksCount: 75,
                createdAt: "2023-01-02T00:00:00Z",
                updatedAt: "2023-01-02T00:00:00Z",
                owner: RepositoryOwner(
                    id: 1,
                    login: "google",
                    avatarUrl: "https://github.com/google.png",
                    htmlUrl: "https://github.com/google"
                )
            )
        ]
    }
}

// MARK: - Mock Classes
class MockSearchRepositoriesUseCase: SearchRepositoriesUseCaseProtocol {
    var mockResponse: SearchRepositoriesResponse?
    var shouldFail = false
    var mockError: Error?
    
    func execute(query: String, page: Int, perPage: Int) -> AnyPublisher<SearchRepositoriesResponse, Error> {
        if shouldFail {
            return Fail(error: mockError ?? GitHubAPIError.noData)
                .eraseToAnyPublisher()
        }
        
        let response = mockResponse ?? SearchRepositoriesResponse(totalCount: 0, items: [])
        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class MockGetGoogleRepositoriesUseCase: GetGoogleRepositoriesUseCaseProtocol {
    var mockRepositories: [Repository] = []
    var shouldFail = false
    var mockError: Error?
    
    func execute(page: Int, perPage: Int) -> AnyPublisher<[Repository], Error> {
        if shouldFail {
            return Fail(error: mockError ?? GitHubAPIError.noData)
                .eraseToAnyPublisher()
        }
        
        return Just(mockRepositories)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
