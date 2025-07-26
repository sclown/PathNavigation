//
//  NavigationState.swift
//

import Foundation

struct PathNavigationState<NavigationRoute: Hashable> {
    typealias Route = NavigationRoute
    var path: [PathNavigationItem<NavigationRoute>]
    var stack: PathStackFragments<NavigationRoute>?
    let rootID: String
    var frameStates = [String: PathNavigationFrameState<NavigationRoute>]()
    var top: PathNavigationItem<NavigationRoute>?

    init(root: NavigationRoute) {
        let item = PathNavigationItem(root, .root)
        self.init(path: [item], stack: nil)
    }

    init(stack root: NavigationRoute) {
        let item = PathNavigationItem(root, .root)
        self.init(path: [], stack: PathStackFragments(root: item, pages: []))
    }

    init(
        path: [PathNavigationItem<NavigationRoute>] = [],
        stack: PathStackFragments<NavigationRoute>? = nil
    ) {
        self.path = path
        self.stack = stack
        rootID = "root"
        updateFrameStates()
        top = path.last ?? stack?.root
    }
}

public struct PathStackFragments<NavigationRoute: Hashable>: Hashable {
    public let root: PathNavigationItem<NavigationRoute>
    public var pages: [PathNavigationItem<NavigationRoute>]
}

