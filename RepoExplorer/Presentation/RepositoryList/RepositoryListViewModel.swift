//
//  RepositoryListViewModel.swift
//  RepoExplorer
//
//  Created by Hussien Awada on 29/09/2025.
//

import Foundation
import Combine

@MainActor
class RepositoryListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var repositories: [Repository] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showingError: Bool = false
    
    private let searchUseCase: SearchRepositoriesUseCaseProtocol
    private let getGoogleRepositoriesUseCase: GetGoogleRepositoriesUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    private let searchDebounceTime: TimeInterval = 0.5
    
    init(
        searchUseCase: SearchRepositoriesUseCaseProtocol,
        getGoogleRepositoriesUseCase: GetGoogleRepositoriesUseCaseProtocol
    ) {
        self.searchUseCase = searchUseCase
        self.getGoogleRepositoriesUseCase = getGoogleRepositoriesUseCase
        setupSearchSubscription()
    }
    
    func searchRepositories() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            repositories = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        searchUseCase.execute(query: searchText, page: 1, perPage: 20)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    self?.repositories = response.items
                }
            )
            .store(in: &cancellables)
    }
    
    func loadInitialRepositories() {
        isLoading = true
        errorMessage = nil
        
        getGoogleRepositoriesUseCase.execute(page: 1, perPage: 20)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] repositories in
                    self?.repositories = repositories
                }
            )
            .store(in: &cancellables)
    }
    
    func clearSearch() {
        searchText = ""
        repositories = []
    }
    
    private func setupSearchSubscription() {
        $searchText
            .debounce(for: .seconds(searchDebounceTime), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.searchRepositories()
            }
            .store(in: &cancellables)
    }
    
    private func handleError(_ error: RepositoryError) {
        errorMessage = error.errorDescription
        showingError = true
    }
}
