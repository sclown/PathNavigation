//
//  File.swift
//  Navigation
//
//  Created by Dmitry Kurkin on 11.04.25.
//

import Foundation

public class NavigationViewModel: ObservableObject {
    @Published var state = PathNavigationState()
    private let topChanged: (AnyHashable) -> Void

    public init(
        root: AnyHashable,
        topChanged: @escaping (AnyHashable) -> Void = { _ in }
    ) {
        state = PathNavigationState(root: root)
        self.topChanged = topChanged
    }

    public init(
        stack root: AnyHashable,
        topChanged: @escaping (AnyHashable) -> Void = { _ in }
    ) {
        state = PathNavigationState(stack: root)
        self.topChanged = topChanged
    }

    init(
        state: PathNavigationState = .init(),
        topChanged: @escaping (AnyHashable) -> Void = { _ in }
    ) {
        self.state = state
        self.topChanged = topChanged
    }

    public func present(_ fragment: AnyHashable, transition: NavigationTransition) {
        state.add(item: PathNavigationItem(fragment, transition))
        topChanged(state.updateTop()?.fragment)
    }

    public func dismiss() {
        state.removeLast()
        topChanged(state.updateTop()?.fragment)
    }

    public func allowTransition(for itemID: String) {
        state.lastItems[itemID]?.allowTransition = true
    }

    public func removeLast(stepID: String?) {
        if let stepID, state.lastItems[stepID] != nil {
            state.handleDismissed(stepID: stepID)
            topChanged(state.updateTop()?.fragment)
        }
    }

    public func replace(
        stack: [AnyHashable],
        path: [(AnyHashable, NavigationTransition)]
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
        topChanged(state.updateTop()?.fragment)
    }

    public func replacePath(
        _ path: [AnyHashable],
        transitionMap: @escaping (AnyHashable) -> NavigationTransition?
    ) {
        let items = path.compactMap { fragment in
            if let transition = transitionMap(fragment) {
                PathNavigationItem(fragment, transition)
            } else {
                nil
            }
        }
        state.reset(to: items)
        topChanged(state.updateTop()?.fragment)
    }

    public func replaceStackPath(_ path: [PathNavigationItem]) {
        state.applyStack(path: path)
        topChanged(state.updateTop()?.fragment)
    }
}
