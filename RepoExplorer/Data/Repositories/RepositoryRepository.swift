//
//  RepositoryRepository.swift
//  RepoExplorer
//
//  Created by Hussien Awada on 29/09/2025.
//

import Foundation
import Combine

class RepositoryRepository: RepositoryRepositoryProtocol {
    private let apiService: GitHubAPIServiceProtocol
    
    init(apiService: GitHubAPIServiceProtocol = GitHubAPIService()) {
        self.apiService = apiService
    }
    
    func searchRepositories(query: String, page: Int, perPage: Int) -> AnyPublisher<SearchRepositoriesResponse, Error> {
        return apiService.searchRepositories(query: query, page: page, perPage: perPage)
    }
    
    func getGoogleRepositories(page: Int, perPage: Int) -> AnyPublisher<[Repository], Error> {
        return apiService.getGoogleRepositories(page: page, perPage: perPage)
    }
}
