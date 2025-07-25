//
//  InputRequest.swift
//

import Combine
import Foundation

public protocol InputNavigationRoute: Hashable, Sendable {
    var isConfirmation: Bool { get }
    static var dismissingPath: Self { get }
}

@available(iOS 18.0, *)
@MainActor
public class InputRequest<NavigationRoute> where NavigationRoute: InputNavigationRoute {
    private let router: (NavigationRoute) -> Void
    private let routerStream: any AsyncSequence<NavigationRoute, Never>
    private let top: any AsyncSequence<NavigationRoute, Never>

    public init(
        router: @escaping (NavigationRoute) -> Void,
        routerStream: any AsyncSequence<NavigationRoute, Never>,
        top: any AsyncSequence<NavigationRoute, Never>
    ) {
        self.router = router
        self.routerStream = routerStream
        self.top = top
    }
    
    public func requestInput(
        _ inputPicker: NavigationRoute
    ) async -> NavigationRoute {
        router(inputPicker)
        let (stream, subject) = AsyncStream.makeStream(of: NavigationRoute.self)
        let confirmations = Task {
            for await route in routerStream where route.isConfirmation {
                subject.yield(route)
            }
        }
        let dismisses = Task {
            for await path in top where path != inputPicker {
                subject.yield(NavigationRoute.dismissingPath)
            }
        }
        let result = await stream.first { @Sendable _ in true }
        confirmations.cancel()
        dismisses.cancel()
        return result ?? .dismissingPath
    }
}
