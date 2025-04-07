//
//  RequestView.swift
//  Example
//
//  Created by Dmitry Kurkin on 18.07.25.
//

import Combine
import SwiftUI

struct RequestView: View {
    let router: PassthroughSubject<ExampleRoute, Never>
    let request: InputRequest<ExampleRoute>
    @State private var text: String = ""

    init(
        router: PassthroughSubject<ExampleRoute, Never>,
        request: InputRequest<ExampleRoute>
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
