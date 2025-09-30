//
//  SplashView.swift
//  RepoExplorer
//
//  Created by Hussien Awada on 29/09/2025.
//

import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel: SplashViewModel
    
    init(coordinator: AppCoordinator) {
        self._viewModel = StateObject(wrappedValue: SplashViewModel(coordinator: coordinator))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Image(systemName: "magnifyingglass.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                    .scaleEffect(viewModel.isLoading ? 1.0 : 1.2)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: viewModel.isLoading)
                
                Text("RepoExplorer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Discover Google's GitHub Repositories")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                }
            }
        }
    }
}

#Preview {
    SplashView(coordinator: AppCoordinator())
}
