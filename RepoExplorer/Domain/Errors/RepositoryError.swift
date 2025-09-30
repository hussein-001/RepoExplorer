//
//  RepositoryError.swift
//  RepoExplorer
//
//  Created by Hussien Awada on 30/09/2025.
//

import Foundation

enum RepositoryError: Error, LocalizedError, Equatable {
    case networkUnavailable
    case invalidSearchQuery
    case repositoryNotFound
    case rateLimitExceeded
    case serverError
    case unknown(description: String)
    
    var errorDescription: String? {
        switch self {
        case .networkUnavailable:
            return "Unable to connect to the internet. Please check your connection and try again."
        case .invalidSearchQuery:
            return "Please enter a valid search term."
        case .repositoryNotFound:
            return "No repositories found for your search. Try different keywords."
        case .rateLimitExceeded:
            return "Too many requests. Please wait a moment and try again."
        case .serverError:
            return "Something went wrong on our end. Please try again later."
        case .unknown(let description):
            return "An unexpected error occurred: \(description)"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .networkUnavailable:
            return "Network connection is required to search repositories."
        case .invalidSearchQuery:
            return "Search query cannot be empty or contain only whitespace."
        case .repositoryNotFound:
            return "No repositories match your search criteria."
        case .rateLimitExceeded:
            return "GitHub API rate limit has been exceeded."
        case .serverError:
            return "GitHub servers are experiencing issues."
        case .unknown(let description):
            return "Unexpected error: \(description)"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkUnavailable:
            return "Check your internet connection and try again."
        case .invalidSearchQuery:
            return "Enter a search term with at least one character."
        case .repositoryNotFound:
            return "Try searching with different keywords or check your spelling."
        case .rateLimitExceeded:
            return "Wait a few minutes before searching again."
        case .serverError:
            return "Please try again in a few moments."
        case .unknown:
            return "If the problem persists, please contact support."
        }
    }
}
