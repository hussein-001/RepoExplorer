//
//  GitHubAPIService.swift
//  RepoExplorer
//
//  Created by Hussien Awada on 29/09/2025.
//

import Foundation
import Combine

protocol GitHubAPIServiceProtocol {
    func searchRepositories(query: String, page: Int, perPage: Int) -> AnyPublisher<SearchRepositoriesResponse, Error>
    func getGoogleRepositories(page: Int, perPage: Int) -> AnyPublisher<[Repository], Error>
}

class GitHubAPIService: GitHubAPIServiceProtocol {
    private let session: URLSession
    private let baseURL = "https://api.github.com"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func searchRepositories(query: String, page: Int, perPage: Int) -> AnyPublisher<SearchRepositoriesResponse, Error> {
        guard let url = buildSearchURL(query: query, page: page, perPage: perPage) else {
            return Fail(error: GitHubAPIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: SearchRepositoriesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getGoogleRepositories(page: Int, perPage: Int) -> AnyPublisher<[Repository], Error> {
        guard let url = buildGoogleRepositoriesURL(page: page, perPage: perPage) else {
            return Fail(error: GitHubAPIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Repository].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func buildSearchURL(query: String, page: Int, perPage: Int) -> URL? {
        var components = URLComponents(string: "\(baseURL)/search/repositories")
        components?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage)),
            URLQueryItem(name: "sort", value: "stars"),
            URLQueryItem(name: "order", value: "desc")
        ]
        return components?.url
    }
    
    private func buildGoogleRepositoriesURL(page: Int, perPage: Int) -> URL? {
        var components = URLComponents(string: "\(baseURL)/orgs/google/repos")
        components?.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage)),
            URLQueryItem(name: "sort", value: "updated"),
            URLQueryItem(name: "direction", value: "desc")
        ]
        return components?.url
    }
}

enum GitHubAPIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode data"
        }
    }
}
