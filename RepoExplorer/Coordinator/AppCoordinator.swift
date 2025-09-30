//
//  AppCoordinator.swift
//  RepoExplorer
//
//  Created by Hussien Awada on 29/09/2025.
//

import SwiftUI

enum AppState {
    case splash
    case main
}

class AppCoordinator: ObservableObject {
    @Published var currentState: AppState = .splash
    
    func navigateToMain() {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentState = .main
        }
    }
}
