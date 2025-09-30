//
//  ErrorMapper.swift
//  RepoExplorer
//
//  Created by Hussien Awada on 30/09/2025.
//

import Foundation

struct ErrorMapper {
    
    static func mapGitHubAPIError(_ error: GitHubAPIError) -> RepositoryError {
        switch error {
        case .invalidURL:
            return .serverError
        case .noData:
            return .repositoryNotFound
        case .decodingError:
            return .serverError
        }
    }
    
    static func mapURLError(_ error: URLError) -> RepositoryError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost, .cannotConnectToHost:
            return .networkUnavailable
        case .timedOut:
            return .networkUnavailable
        case .cannotFindHost, .cannotLoadFromNetwork:
            return .networkUnavailable
        default:
            return .unknown(description: error.localizedDescription)
        }
    }
    
    static func mapHTTPStatusCode(_ statusCode: Int) -> RepositoryError {
        switch statusCode {
        case 400...499:
            if statusCode == 403 {
                return .rateLimitExceeded
            }
            return .invalidSearchQuery
        case 500...599:
            return .serverError
        default:
            return .unknown(description: "HTTP \(statusCode)")
        }
    }
    
    static func mapError(_ error: Error) -> RepositoryError {
        if let urlError = error as? URLError {
            return mapURLError(urlError)
        }
        
        if let githubError = error as? GitHubAPIError {
            return mapGitHubAPIError(githubError)
        }
        
        if let httpError = error as? HTTPError {
            return mapHTTPStatusCode(httpError.statusCode)
        }
        
        return .unknown(description: error.localizedDescription)
    }
}

struct HTTPError: Error {
    let statusCode: Int
    let message: String?
    
    init(statusCode: Int, message: String? = nil) {
        self.statusCode = statusCode
        self.message = message
    }
}
