# PathNavigation

Navigation framework for SwiftUI applications. It handles most of navigation operations in one common way similar to NavigationStack. Presentation of sheets, alerts, submodules could be done through the path.

## Features

*   **Declarative Navigation**: Define navigation paths and flows in a clear, declarative way.
*   **Decoupled**: Separates navigation logic from your views, improving modularity and testability.
*   **Child modules**: Navigation could show another navigation module with the different route type.

## Installation

You can add `Navigation` to your project using Swift Package Manager. In your `Package.swift` file, add the following dependency:

```swift
dependencies: [
    .package(url: "https://github.com/your-username/Navigation.git", from: "0.2.0")
]
```

Then, add the desired products to your target's dependencies:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "InputRequest", package: "Navigation"),
        // Optionally add Combine support
        .product(name: "InputRequestCombine", package: "Navigation")
    ]
),
```

## Usage

### Basic Setup

1. Define your navigation routes:

```swift
enum AppRoute: Hashable {
    case root
    case next
    case dismiss
}
```

2. Define destinations for routes:

```swift
@ViewBuilder
func destination(_ path: AppRoute?) -> some View {
    switch path {
    case .root: HomeView()
    case .next: DetailView()
    default: EmptyView()
    }
}
```

3. Define navigation actions:

```swift
func route(_ route: AppRoute) {
    switch route {
    case .root: break
    case .next: navigation.present(.next, transition: .sheet)
    case .dismiss: navigation.dismiss()
    }
}
```

4. Create a navigation view model:

```swift
let navigation = NavigationViewModel(root: AppRoute.root)
```

5. Use PathNavigationView:

```swift
struct ContentView: View {
    var body: some View {
        PathNavigationView(
            viewModel: navigation,
            destinations: { destination($0) }
        )
    }
}
```

5. Apply navigation in views:

```swift
Button("Push") { route(.next) }
```

Check Example project for more details.

## Modules

Framework comes with supporting modules for handling navigation cases like alerts or pickers. One shows the screen for some input and need results from it. It very convenient to have it as an async function or Combine's Publisher. 

*   **`InputRequestCombine`**: provides solution with the dependency on Combine
*   **`InputRequest`**: provides solution without combine, but requires iOS 18

## Contributing

Contributions are welcome! Please feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License.