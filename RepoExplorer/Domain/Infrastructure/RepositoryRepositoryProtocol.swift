//
//  RepositoryRepositoryProtocol.swift
//  RepoExplorer
//
//  Created by Hussien Awada on 29/09/2025.
//

import Foundation
import Combine

protocol RepositoryRepositoryProtocol {
    func searchRepositories(query: String, page: Int, perPage: Int) -> AnyPublisher<SearchRepositoriesResponse, RepositoryError>
    func getGoogleRepositories(page: Int, perPage: Int) -> AnyPublisher<[Repository], RepositoryError>
}
