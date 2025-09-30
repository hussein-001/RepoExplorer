//
//  SplashViewModel.swift
//  RepoExplorer
//
//  Created by Hussien Awada on 29/09/2025.
//

import Foundation
import Combine

protocol SplashViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }
    var coordinator: AppCoordinator { get }
}

class SplashViewModel: SplashViewModelProtocol {
    @Published var isLoading: Bool = true
    let coordinator: AppCoordinator
    
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        startSplashTimer()
    }
    
    private func startSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.isLoading = false
            self?.coordinator.navigateToMain()
        }
    }
}
