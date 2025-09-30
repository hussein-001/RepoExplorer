//
//  Repository.swift
//  RepoExplorer
//
//  Created by Hussien Awada on 29/09/2025.
//

import Foundation

struct Repository: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let htmlUrl: String
    let language: String?
    let stargazersCount: Int
    let forksCount: Int
    let createdAt: String
    let updatedAt: String
    let owner: RepositoryOwner
    
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

struct RepositoryOwner: Codable, Equatable {
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

struct SearchRepositoriesResponse: Codable {
    let totalCount: Int
    let items: [Repository]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}
