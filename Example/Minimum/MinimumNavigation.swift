//
//  MinimumNavigation.swift
//

import Navigation
import SwiftUI

let navigation = NavigationViewModel(root: MinimumRoute.root)
func route(_ route: MinimumRoute) -> Void {
    switch route {
    case .root: break
    case .next: navigation.present(MinimumRoute.next, transition: .sheet)
    case .dismiss: navigation.dismiss()
    }
}

@ViewBuilder
func destination(_ path: MinimumRoute?) -> some View {
    if case .root = path {
        MinPageView()
    } else if case .next = path {
        MinNextView()
    } else {
        EmptyView()
    }
}

struct MinimumNavigation: View {
    var body: some View {
        PathNavigationView(
            viewModel: navigation,
            destinations: { destination($0) },
        )
    }
}

struct MinPageView: View {
    var body: some View {
        VStack {
            Button("Push") { route(.next) }
        }
    }
}

struct MinNextView: View {
    var body: some View {
        VStack {
            Button("Back") { route(.dismiss) }
        }
    }
}

enum MinimumRoute: Hashable {
    case root
    case next
    case dismiss
}
