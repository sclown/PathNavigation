//
//  NavigationViewModel.swift
//

import Foundation

public class NavigationViewModel<NavigationRoute: Hashable>: ObservableObject {
    @Published var state = PathNavigationState<NavigationRoute>()
    private let topChanged: (NavigationRoute) -> Void

    public init(
        root: NavigationRoute,
        topChanged: @escaping (NavigationRoute) -> Void = { _ in }
    ) {
        state = PathNavigationState(root: root)
        self.topChanged = topChanged
    }

    public init(
        stack root: NavigationRoute,
        topChanged: @escaping (NavigationRoute) -> Void = { _ in }
    ) {
        state = PathNavigationState(stack: root)
        self.topChanged = topChanged
    }

    init(
        state: PathNavigationState<NavigationRoute> = .init(),
        topChanged: @escaping (NavigationRoute) -> Void = { _ in }
    ) {
        self.state = state
        self.topChanged = topChanged
    }

    public func present(_ fragment: NavigationRoute, transition: NavigationTransition) {
        state.add(item: PathNavigationItem(fragment, transition))
        state.updateTop().map { topChanged($0.fragment) }
    }

    public func dismiss() {
        state.removeLast()
        state.updateTop().map { topChanged($0.fragment) }
    }

    public func allowTransition(for itemID: String) {
        state.lastItems[itemID]?.allowTransition = true
    }

    public func removeLast(stepID: String?) {
        if let stepID, state.lastItems[stepID] != nil {
            state.handleDismissed(stepID: stepID)
            state.updateTop().map { topChanged($0.fragment) }
        }
    }

    public func replace(
        stack: [NavigationRoute],
        path: [(NavigationRoute, NavigationTransition)]
    ) {
        if stack.isEmpty == false {
            let root = stack[0]
            let pages = stack.dropFirst().map { PathNavigationItem($0, .push) }
            if state.stack?.root.fragment != root {
                state.stack = PathStackFragments(
                    root: PathNavigationItem(root, .root),
                    pages: []
                )
            }
            state.stack?.pages = pages
        }
        state.path = path.map { fragment, transition in
            PathNavigationItem(fragment, transition)
        }
        state.updateLastItems()
        state.updateTop().map { topChanged($0.fragment) }
    }

    public func replacePath(
        _ path: [NavigationRoute],
        transitionMap: @escaping (NavigationRoute) -> NavigationTransition?
    ) {
        let items = path.compactMap { fragment in
            if let transition = transitionMap(fragment) {
                PathNavigationItem(fragment, transition)
            } else {
                nil
            }
        }
        state.reset(to: items)
        state.updateTop().map { topChanged($0.fragment) }
    }

    public func replaceStackPath(_ path: [PathNavigationItem<NavigationRoute>]) {
        state.applyStack(path: path)
        state.updateTop().map { topChanged($0.fragment) }
    }
}
