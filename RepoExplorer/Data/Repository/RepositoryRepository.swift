//
//  RepositoryRepository.swift
//  RepoExplorer
//
//  Created by Hussien Awada on 29/09/2025.
//

import Foundation
import Combine

class RepositoryRepository: RepositoryRepositoryProtocol {
    private let dataSource: RepositoryDataSourceProtocol
    
    init(dataSource: RepositoryDataSourceProtocol = GitHubAPIService()) {
        self.dataSource = dataSource
    }
    
    func searchRepositories(query: String, page: Int, perPage: Int) -> AnyPublisher<SearchRepositoriesResponse, RepositoryError> {
        return dataSource.searchRepositories(query: query, page: page, perPage: perPage)
            .map { response in
                SearchRepositoriesResponse(
                    totalCount: response.totalCount,
                    items: response.items.map { RepositoryDataMapper.mapGitHubRepository($0) }
                )
            }
            .mapError { ErrorMapper.mapError($0) }
            .eraseToAnyPublisher()
    }
    
    func getGoogleRepositories(page: Int, perPage: Int) -> AnyPublisher<[Repository], RepositoryError> {
        return dataSource.getGoogleRepositories(page: page, perPage: perPage)
            .map { repositories in
                repositories.map { RepositoryDataMapper.mapGitHubRepository($0) }
            }
            .mapError { ErrorMapper.mapError($0) }
            .eraseToAnyPublisher()
    }
}
