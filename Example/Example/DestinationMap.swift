//
//  DestinationMap.swift
//

import Combine
import Navigation
import SwiftUI

@MainActor
struct DestinationsMap {
    let router: PassthroughSubject<ExampleRoute, Never>
    let request: InputRequest<ExampleRoute>

    @ViewBuilder
    func destination(_ destination: AnyHashable) -> some View {
        if let route = destination as? ExampleRoute {
            switch route {
            case .root: PageView(router: router)
            case .push: PageView(router: router)
            case .present: PageView(router: router)
            case .sheet: PageView(router: router)
            case .request: RequestView(
                router: router,
                request: request
            )
            case .child: child()
            default: EmptyView()
            }
        } else {
            EmptyView()
        }
    }

    func alert(for route: AnyHashable) -> AlertElements {
        if case let .alert(message) = (route as? ExampleRoute) {
            return AlertElements(
                title: "Alert with",
                buttonsBuilder: {
                    Button("Close", role: .cancel) {}
                },
                messageBuilder: {
                    Text(message)
                }
            )
        }
        return AlertElements(
            title: "The Divine Comedy",
            buttonsBuilder: {
                Button("Eternal pain", role: .destructive) {
                    router.send(.confirm("Through me you pass into eternal pain"))
                }
                Button("The city of woe", role: .none) {
                    router.send(.confirm("Through me you pass into the city of woe"))
                }
                Button("Lost for aye", role: .none) {
                    router.send(.confirm("Through me among the people lost for aye"))
                }
                Button("Cancel", role: .cancel) {}
            },
            messageBuilder: {
                Text("Abandon hope all ye who enter here")
            }
        )
    }
    
    private func child() -> some View {
        ExampleNavigation()
            .observe { route in
                switch route {
                case .dismiss: router.send(.back)
                default: break
                }
            }
    }
}

enum ExampleRoute: Hashable {
    case root
    case push
    case present
    case sheet
    case child
    case alert(String)
    case back
    case dismiss
    case request
    case input
    case confirm(String)
}

extension ExampleRoute: InputNavigationRoute {
    var isConfirmation: Bool {
        if case .confirm = self {
            return true
        }
        return false
    }
    
    static var dismissingPath: ExampleRoute {
        .dismiss
    }
}
