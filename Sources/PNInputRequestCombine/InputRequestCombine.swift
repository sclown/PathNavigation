//
//  InputRequestCombine.swift
//

import Combine
import Foundation

public protocol InputNavigationRoute: Hashable, Sendable {
    var isConfirmation: Bool { get }
    static var dismissingPath: Self { get }
}

@MainActor
public class InputRequestCombine<NavigationRoute> where NavigationRoute: InputNavigationRoute {
    private let router: PassthroughSubject<NavigationRoute, Never>
    private let top: AnyPublisher<NavigationRoute, Never>
    
    public init(
        router: PassthroughSubject<NavigationRoute, Never>,
        top: AnyPublisher<NavigationRoute, Never>
    ) {
        self.router = router
        self.top = top
    }
    
    public func requestInput(
        _ inputPicker: NavigationRoute
    ) async -> NavigationRoute {
        for await value in requestInput(inputPicker).values {
            return value
        }
        return .dismissingPath
    }
    
    public func requestInput(
        _ inputPicker: NavigationRoute
    ) -> AnyPublisher<NavigationRoute, Never> {
        router.send(inputPicker)
        let results = router.filter { $0.isConfirmation }
        let current = top.compactMap {
            @Sendable in $0 == inputPicker ? nil : NavigationRoute.dismissingPath
        }
        return results.merge(with: current)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
