//
//  RepoExplorerApp.swift
//  RepoExplorer
//
//  Created by Hussien Awada on 29/09/2025.
//

import SwiftUI

@main
struct RepoExplorerApp: App {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch coordinator.currentState {
                case .splash:
                    SplashView(coordinator: coordinator)
                case .main:
                    RepositoryListView()
                }
            }
            .environmentObject(coordinator)
        }
    }
}
