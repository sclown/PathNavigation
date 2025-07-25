//
//  RequestView.swift
//

import Combine
import InputRequestCombine
import SwiftUI

struct RequestView: View {
    let router: PassthroughSubject<ExampleRoute, Never>
    let request: InputRequestCombine<ExampleRoute>
    @State private var text: String = ""

    init(
        router: PassthroughSubject<ExampleRoute, Never>,
        request: InputRequestCombine<ExampleRoute>
    ) {
        self.router = router
        self.request = request
    }

    var body: some View {
        VStack {
            Button("Pop", action: {
                router.send(.back)
            })
            Button("Request input") {
                Task {
                    let result = await request.requestInput(.input)
                    if case let .confirm(value) = result {
                        text = value
                    }
                }
            }
            Text(text)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) { Text("Leading") }
            ToolbarItemGroup(placement: .navigationBarTrailing) { Text("Trailing") }
        }
    }
}
