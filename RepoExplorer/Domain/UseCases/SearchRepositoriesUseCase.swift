//
//  SearchRepositoriesUseCase.swift
//  RepoExplorer
//
//  Created by Hussien Awada on 29/09/2025.
//

import Foundation
import Combine

protocol SearchRepositoriesUseCaseProtocol {
    func execute(query: String, page: Int, perPage: Int) -> AnyPublisher<SearchRepositoriesResponse, RepositoryError>
}

class SearchRepositoriesUseCase: SearchRepositoriesUseCaseProtocol {
    private let repository: RepositoryRepositoryProtocol
    
    init(repository: RepositoryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(query: String, page: Int, perPage: Int) -> AnyPublisher<SearchRepositoriesResponse, RepositoryError> {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedQuery.isEmpty {
            return Fail(error: RepositoryError.invalidSearchQuery)
                .eraseToAnyPublisher()
        }
        
        return repository.searchRepositories(query: trimmedQuery, page: page, perPage: perPage)
    }
}

protocol GetGoogleRepositoriesUseCaseProtocol {
    func execute(page: Int, perPage: Int) -> AnyPublisher<[Repository], RepositoryError>
}

class GetGoogleRepositoriesUseCase: GetGoogleRepositoriesUseCaseProtocol {
    private let repository: RepositoryRepositoryProtocol
    
    init(repository: RepositoryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(page: Int, perPage: Int) -> AnyPublisher<[Repository], RepositoryError> {
        return repository.getGoogleRepositories(page: page, perPage: perPage)
    }
}
