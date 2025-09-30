//
//  RepositoryDataMapper.swift
//  RepoExplorer
//
//  Created by Hussien Awada on 30/09/2025.
//

import Foundation

struct RepositoryDataMapper {
    
    static func mapGitHubRepository(_ apiRepository: GitHubRepositoryResponse) -> Repository {
        return Repository(
            id: apiRepository.id,
            name: apiRepository.name,
            fullName: apiRepository.fullName,
            description: apiRepository.description,
            htmlUrl: apiRepository.htmlUrl,
            language: apiRepository.language,
            stargazersCount: apiRepository.stargazersCount,
            forksCount: apiRepository.forksCount,
            createdAt: parseDate(apiRepository.createdAt),
            updatedAt: parseDate(apiRepository.updatedAt),
            owner: mapOwner(apiRepository.owner)
        )
    }
    
    private static func mapOwner(_ apiOwner: GitHubOwnerResponse) -> Owner {
        return Owner(
            id: apiOwner.id,
            login: apiOwner.login,
            avatarUrl: apiOwner.avatarUrl,
            htmlUrl: apiOwner.htmlUrl
        )
    }
    
    private static func parseDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = formatter.date(from: dateString) {
            return date
        }
        
        let fallbackFormatter = DateFormatter()
        fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return fallbackFormatter.date(from: dateString)
    }
}

// MARK: - API Response Models

struct GitHubRepositoryResponse: Codable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let htmlUrl: String
    let language: String?
    let stargazersCount: Int
    let forksCount: Int
    let createdAt: String?
    let updatedAt: String?
    let owner: GitHubOwnerResponse
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, language, owner
        case fullName = "full_name"
        case htmlUrl = "html_url"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct GitHubOwnerResponse: Codable {
    let id: Int
    let login: String
    let avatarUrl: String
    let htmlUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }
}

struct GitHubSearchRepositoriesResponse: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [GitHubRepositoryResponse]
    
    enum CodingKeys: String, CodingKey {
        case items
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
    }
}
