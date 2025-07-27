//
//  NavigationStack.swift
//

import SwiftUI

struct PathNavigationStack<Content, NavigationRoute>: View where Content: View, NavigationRoute: Hashable {
    let root: PathNavigationItem<NavigationRoute>
    let stackBinding: Binding<[PathNavigationItem<NavigationRoute>]>
    let destinations: (NavigationRoute) -> Content

    var body: some View {
        NavigationStack(path: stackBinding) {
            destinations(root.fragment)
                .navigationDestination(for: PathNavigationItem.self) {
                    destinations($0.fragment)
                }
        }
    }
}
