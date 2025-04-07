//
//  HostViewModel.swift
//

import Combine
import Foundation
import Navigation

@MainActor
class NavigationHostViewModel {
    let router: PassthroughSubject<ExampleRoute, Never>
    let destination: DestinationsMap
    let navigation: NavigationViewModel
    let navigationSubscription: AnyCancellable?
    var external: AnyCancellable?
    
    let top: PassthroughSubject<AnyHashable, Never>
    
    init() {
        let router = PassthroughSubject<ExampleRoute, Never>()
        let top = PassthroughSubject<AnyHashable, Never>()
        let navigation = NavigationViewModel(stack: ExampleRoute.root) { top.send($0) }
        let request = InputRequest(router: router, top: top.eraseToAnyPublisher())
        self.router = router
        self.navigation = navigation
        self.top = top
        destination = DestinationsMap(router: router, request: request)
        
        navigationSubscription = router.sink { route in
            switch route {
            case .root: navigation.replace(stack: [route], path: [])
            case .push: navigation.present(route, transition: .push)
            case .present: navigation.present(route, transition: .fullScreen)
            case .sheet: navigation.present(route, transition: .sheet)
            case .child: navigation.present(route, transition: .fullScreen)
            case .alert: navigation.present(route, transition: .alert)
            case .input: navigation.present(route, transition: .alert)
            case .request: navigation.present(route, transition: .sheet)
            case .back: navigation.dismiss()
            case .dismiss: break
            case .confirm: break
            }
        }
    }
    
    func observe(sink: @escaping (ExampleRoute) -> Void) {
        external = router.sink(receiveValue: sink)
    }
}
