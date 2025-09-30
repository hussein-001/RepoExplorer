//
//  RepositoryDataSourceProtocol.swift
//  RepoExplorer
//
//  Created by Hussien Awada on 30/09/2025.
//

import Foundation
import Combine

protocol RepositoryDataSourceProtocol {
    func searchRepositories(query: String, page: Int, perPage: Int) -> AnyPublisher<GitHubSearchRepositoriesResponse, Error>
    func getGoogleRepositories(page: Int, perPage: Int) -> AnyPublisher<[GitHubRepositoryResponse], Error>
}
