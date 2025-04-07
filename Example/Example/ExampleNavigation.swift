//
//  ExampleNavigation.swift
//

import Navigation
import SwiftUI

struct ExampleNavigation: View {
    @State var viewModel = NavigationHostViewModel()

    init() {}

    init(external: @escaping (ExampleRoute) -> Void ) {
        viewModel.observe(sink: external)
    }
    
    func observe(external: @escaping (ExampleRoute) -> Void ) -> Self {
        viewModel.observe(sink: external)
        return self
    }

    var body: some View {
        PathNavigationView(
            viewModel: viewModel.navigation,
            destinations: { viewModel.destination.destination($0) },
            alerts: { viewModel.destination.alert(for: $0) }
        )
    }
}

