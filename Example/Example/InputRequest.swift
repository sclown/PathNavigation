//
//  InputRequest.swift
//  Example
//
//  Created by Dmitry Kurkin on 18.07.25.
//

import Combine
import Foundation

protocol InputNavigationRoute: Hashable {
    var isConfirmation: Bool { get }
    static var dismissingPath: Self { get }
}

@MainActor
class InputRequest<NavigationRoute> where NavigationRoute: InputNavigationRoute {
    private let router: PassthroughSubject<NavigationRoute, Never>
    private let top: AnyPublisher<AnyHashable, Never>

    init(
        router: PassthroughSubject<NavigationRoute, Never>,
        top: AnyPublisher<AnyHashable, Never>
    ) {
        self.router = router
        self.top = top
    }
    
    func requestInput(
        _ inputPicker: NavigationRoute
    ) async -> NavigationRoute {
        router.send(inputPicker)
        let results = router.filter { $0.isConfirmation }
        let current = top.compactMap { current -> NavigationRoute? in
            if (current as? NavigationRoute) == inputPicker {
                return nil
            }
            return NavigationRoute.dismissingPath
        }.receive(on: DispatchQueue.main)
        var subscription: AnyCancellable?
        let result = await withCheckedContinuation { continuation in
            subscription = results.merge(with: current).sink { result in
                continuation.resume(returning: result)
                subscription?.cancel()
            }
        }
        subscription?.cancel()
        return result
    }
}
