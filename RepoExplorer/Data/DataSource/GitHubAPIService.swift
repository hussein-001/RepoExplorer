//
//  GitHubAPIService.swift
//  RepoExplorer
//
//  Created by Hussien Awada on 29/09/2025.
//

import Foundation
import Combine

class GitHubAPIService: RepositoryDataSourceProtocol {
    private let session: URLSession
    private let baseURL = "https://api.github.com"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func searchRepositories(query: String, page: Int, perPage: Int) -> AnyPublisher<GitHubSearchRepositoriesResponse, Error> {
        guard let url = buildSearchURL(query: query, page: page, perPage: perPage) else {
            return Fail(error: GitHubAPIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        throw HTTPError(statusCode: httpResponse.statusCode)
                    }
                }
                return data
            }
            .decode(type: GitHubSearchRepositoriesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getGoogleRepositories(page: Int, perPage: Int) -> AnyPublisher<[GitHubRepositoryResponse], Error> {
        guard let url = buildGoogleRepositoriesURL(page: page, perPage: perPage) else {
            return Fail(error: GitHubAPIError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response in
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        throw HTTPError(statusCode: httpResponse.statusCode)
                    }
                }
                return data
            }
            .decode(type: [GitHubRepositoryResponse].self, decoder: JSONDecoder())
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
