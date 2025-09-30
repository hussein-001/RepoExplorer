//
//  RepositoryDetailView.swift
//  RepoExplorer
//
//  Created by Hussien Awada on 29/09/2025.
//

import SwiftUI

struct RepositoryDetailView: View {
    let repository: Repository
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Owner Avatar
                AsyncImage(url: URL(string: repository.owner.avatarUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.gray)
                                .font(.largeTitle)
                        )
                }
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                
                // Repository Information
                VStack(spacing: 12) {
                    // Repository Name
                    Text(repository.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    // Creation Date
                    Text("Created \(formatCreationDate(repository.createdAt))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Language Badge (if available)
                    if let language = repository.language {
                        Text(language)
                            .font(.caption)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .cornerRadius(12)
                    }
                }
                
                // Stargazers Count
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.title2)
                        
                        Text("\(repository.stargazersCount)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                    
                    Text("Stargazers")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Repository Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func formatCreationDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        
        return dateString
    }
}

#Preview {
    RepositoryDetailView(repository: Repository(
        id: 1,
        name: "Sample Repository",
        fullName: "google/sample-repo",
        description: "This is a sample repository description.",
        htmlUrl: "https://github.com/google/sample-repo",
        language: "Swift",
        stargazersCount: 1234,
        forksCount: 567,
        createdAt: "2023-01-01T00:00:00Z",
        updatedAt: "2023-12-01T00:00:00Z",
        owner: RepositoryOwner(
            id: 1,
            login: "google",
            avatarUrl: "https://github.com/google.png",
            htmlUrl: "https://github.com/google"
        )
    ))
}
