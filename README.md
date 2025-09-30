# RepoExplorer

A SwiftUI iOS application that displays and searches Google's repositories from GitHub, demonstrating modern iOS development practices with Clean Architecture, MVVM pattern, Coordinator pattern for navigation, and comprehensive testing.

## Features Implemented

### Screen 1: Splash Screen ✅
- Beautiful animated splash screen with gradient background
- App branding with animated icon
- Automatic navigation to main screen after 3 seconds
- Smooth transitions with SwiftUI animations

### Screen 2: Repository List with Search ✅
- **Search bar with real-time search** (searches while typing with 0.5s debounce)
- **Clean repository list** displaying:
  - **Repository name** (prominently displayed)
  - **Creation date** (formatted in a readable format)
  - **Owner avatar image** (loaded asynchronously from GitHub)
  - **Language badge** (when available)
- **GitHub API integration** for fetching Google's repositories
- **Search functionality** across all GitHub repositories
- **Loading states** and error handling
- **Pull-to-refresh** functionality
- **Empty state** handling with helpful messages

### Screen 3: Simple Repository Detail View ✅
- **Simple, clean display** of the same data from the clicked repository item
- **All data from Screen 2** plus:
  - **Stargazers count** prominently displayed with star icon
- **Minimal design** with:
  - **Owner avatar** (larger, centered)
  - **Repository name** (title format)
  - **Creation date** (formatted)
  - **Language badge** (when available)
  - **Stargazers count** (highlighted in a card)
- **Modal presentation** with smooth dismiss functionality
- **Clean, focused layout** without overwhelming information

## Architecture

The project follows **Clean Architecture** with proper separation of concerns:

### Domain Layer
- **Entities**: `Repository`, `RepositoryOwner`, `SearchRepositoriesResponse`
- **Use Cases**: `SearchRepositoriesUseCase`, `GetGoogleRepositoriesUseCase`
- **Repository Protocols**: `RepositoryRepositoryProtocol`

### Data Layer
- **Network Service**: `GitHubAPIService` with GitHub API integration
- **Repository Implementation**: `RepositoryRepository`
- **Error Handling**: `GitHubAPIError` with localized descriptions

### Presentation Layer
- **Views**: SwiftUI views with modern design
- **ViewModels**: `RepositoryListViewModel` with reactive state management
- **Coordinator**: `AppCoordinator` for navigation flow

### Key Features
- **MVVM Pattern** with reactive programming using Combine
- **Coordinator Pattern** for clean navigation management
- **Protocol-based design** for testability and dependency injection
- **Real-time search** with debouncing for optimal performance
- **Error handling** with user-friendly messages
- **Loading states** with progress indicators
- **AsyncImage** for efficient avatar loading with placeholder
- **Modal navigation** for detailed views

## Project Structure

```
RepoExplorer/
├── Domain/
│   ├── Entities/
│   │   └── Repository.swift                    # Repository data models
│   ├── UseCases/
│   │   └── SearchRepositoriesUseCase.swift     # Business logic
│   └── Repositories/
│       └── RepositoryRepositoryProtocol.swift  # Repository interface
├── Data/
│   ├── Network/
│   │   └── GitHubAPIService.swift             # GitHub API integration
│   └── Repositories/
│       └── RepositoryRepository.swift         # Repository implementation
├── Features/
│   ├── Splash/
│   │   ├── SplashView.swift                   # Splash screen UI
│   │   └── SplashViewModel.swift              # Splash screen logic
│   ├── RepositoryList/
│   │   ├── RepositoryListView.swift           # Repository list UI
│   │   └── RepositoryListViewModel.swift      # Repository list logic
│   └── RepositoryDetail/
│       └── RepositoryDetailView.swift         # Simple repository detail UI
├── Coordinator/
│   └── AppCoordinator.swift                   # Navigation coordinator
├── RepoExplorerApp.swift                      # Main app entry point
└── ContentView.swift                          # Default SwiftUI view
```

## Repository Detail Features

### Simple Design
- **Centered layout** with clear visual hierarchy
- **Large avatar** for better visual impact
- **Repository name** as the main title
- **Creation date** in readable format
- **Language badge** when available
- **Stargazers count** prominently displayed in a card

### Data Display
- **Same data as Screen 2**: Repository name, creation date, avatar, language
- **Additional information**: Stargazers count with visual star icon
- **Clean formatting**: Consistent typography and spacing
- **Minimal information**: Focused on essential details only

### User Experience
- **Modal presentation** with smooth animations
- **Simple dismiss** with Done button
- **Clean, uncluttered interface** for easy reading
- **Responsive design** that works on all screen sizes
- **Fast loading** with efficient image caching

## Testing

The project includes comprehensive testing:

### Unit Tests
- **SplashViewModelTests**: Tests splash screen logic and timer functionality
- **RepositoryListViewModelTests**: Tests search functionality, API calls, and state management
- Tests verify initial state, search behavior, error handling, and navigation timing

### UI Tests
- **SplashScreenUITests**: Tests splash screen UI elements and navigation
- **RepositoryListUITests**: Tests search functionality, UI elements, and user interactions
- **RepositoryDetailUITests**: Tests detail view navigation, elements, and dismiss functionality
- Verifies UI elements are displayed correctly and user interactions work as expected

## Technologies Used

- **SwiftUI**: Modern declarative UI framework
- **Combine**: Reactive programming for state management
- **Clean Architecture**: Domain, Data, Presentation layers
- **MVVM**: Model-View-ViewModel pattern
- **Coordinator Pattern**: Navigation management
- **GitHub API**: Real-time repository data
- **AsyncImage**: Efficient image loading with placeholders
- **XCTest**: Unit and UI testing framework
- **Modal Navigation**: Sheet presentation for detail views

## Getting Started

1. Open `RepoExplorer.xcodeproj` in Xcode
2. Select an iOS Simulator (iPhone 16 or later)
3. Build and run the project (⌘+R)

## Current Status

✅ **Completed:**
- Splash screen implementation
- Repository list with clean, focused design
- Repository name, creation date, and avatar display
- Simple repository detail view with stargazers count
- GitHub API integration
- Clean Architecture implementation
- Coordinator pattern setup
- MVVM architecture foundation
- Comprehensive testing
- Real-time search with debouncing
- Error handling and loading states
- Beautiful UI with modern design
- AsyncImage integration for avatars
- Modal navigation for detail views

🚧 **Next Steps:**
- Implement repository bookmarking functionality
- Add pagination for large result sets
- Implement offline caching
- Add advanced search filters
- Implement repository sharing functionality

## API Integration

The app integrates with GitHub's REST API:
- **Search Endpoint**: `/search/repositories` for searching repositories
- **Organization Endpoint**: `/orgs/google/repos` for Google's repositories
- **Real-time search** with proper error handling and loading states
- **Avatar images** loaded from GitHub's CDN

## Testing

Run tests using:
```bash
xcodebuild test -project RepoExplorer.xcodeproj -scheme RepoExplorer -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Requirements

- iOS 18.5+
- Xcode 16.0+
- Swift 5.9+
- Internet connection for GitHub API access
