//
//  RepositoryListView.swift
//  RepoExplorer
//
//  Created by Hussien Awada on 29/09/2025.
//

import SwiftUI

struct RepositoryListView: View {
    @StateObject private var viewModel: RepositoryListViewModel
    @State private var selectedRepository: Repository?
    
    init() {
        let repository = RepositoryRepository()
        let searchUseCase = SearchRepositoriesUseCase(repository: repository)
        let getGoogleRepositoriesUseCase = GetGoogleRepositoriesUseCase(repository: repository)
        
        self._viewModel = StateObject(wrappedValue: RepositoryListViewModel(
            searchUseCase: searchUseCase,
            getGoogleRepositoriesUseCase: getGoogleRepositoriesUseCase
        ))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                searchBar
                
                // Content
                if viewModel.isLoading && viewModel.repositories.isEmpty {
                    loadingView
                } else if viewModel.repositories.isEmpty {
                    emptyStateView
                } else {
                    repositoryListView
                }
            }
            .navigationTitle("Repositories")
            .navigationBarTitleDisplayMode(.large)
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK") { }
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred")
            }
            .sheet(item: $selectedRepository) { repository in
                RepositoryDetailView(repository: repository)
            }
        }
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search repositories...", text: $viewModel.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: viewModel.clearSearch) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
            
            Text("Loading repositories...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            if viewModel.searchText.isEmpty {
                Text("Search for repositories")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Use the search bar above to find repositories on GitHub")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            } else if viewModel.isLoading {
                Text("Searching...")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Finding repositories for \"\(viewModel.searchText)\"")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            } else {
                Text("No repositories found")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Try searching for a different term")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Button("Clear Search") {
                    viewModel.clearSearch()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Repository List View
    private var repositoryListView: some View {
        VStack(spacing: 0) {
            // Results count
            if !viewModel.repositories.isEmpty {
                HStack {
                    Text("\(viewModel.repositories.count) repositories found")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            
            // Repository list
            List {
                ForEach(viewModel.repositories) { repository in
                    RepositoryRowView(repository: repository)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            selectedRepository = repository
                        }
                }
            }
            .listStyle(PlainListStyle())
            .refreshable {
                if !viewModel.searchText.isEmpty {
                    viewModel.searchRepositories()
                }
            }
        }
    }
}

// MARK: - Repository Row View
struct RepositoryRowView: View {
    let repository: Repository
    
    var body: some View {
        HStack(spacing: 12) {
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
                            .font(.title2)
                    )
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            // Repository Info
            VStack(alignment: .leading, spacing: 4) {
                // Repository Name
                Text(repository.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                // Creation Date
                Text("Created \(formatCreationDate(repository.createdAt))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Language Badge (if available)
            if let language = repository.language {
                Text(language)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
            
            // Chevron indicator
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
    
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
    RepositoryListView()
}
