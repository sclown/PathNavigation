//
//  PageView.swift
//

import Combine
import SwiftUI

struct PageView: View {
    let router: PassthroughSubject<ExampleRoute, Never>

    init(router: PassthroughSubject<ExampleRoute, Never>) {
        self.router = router
    }

    var body: some View {
        VStack {
            Button("Push", action: {
                router.send(.push)
            })
            Button("Present", action: {
                router.send(.present)
            })
            Button("Sheet", action: {
                router.send(.sheet)
            })
            Button("Child", action: {
                router.send(.child)
            })
            Button("Alert") {
                router.send(.alert("The Inferno, the Purgatorio and the Paradiso"))
            }
            Button("Request input") {
                router.send(.request)
            }
            Button("Pop", action: {
                router.send(.back)
            })
            Button("Root", action: {
                router.send(.root)
            })
            Button("Parent", action: {
                router.send(.dismiss)
            })
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) { Text("Leading") }
            ToolbarItemGroup(placement: .navigationBarTrailing) { Text("Trailing") }
        }
    }
}
