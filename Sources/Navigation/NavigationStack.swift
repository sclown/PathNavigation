//
//  File.swift
//  Navigation
//
//  Created by Dmitry Kurkin on 11.04.25.
//

import SwiftUI

struct PathNavigationStack<Content>: View where Content: View {
    let root: PathNavigationItem
    let stackBinding: Binding<[PathNavigationItem]>
    let destinations: (AnyHashable) -> Content

    var body: some View {
        NavigationStack(path: stackBinding) {
            destinations(root.fragment)
                .navigationDestination(for: PathNavigationItem.self) {
                    destinations($0.fragment)
                }
        }
    }
}
