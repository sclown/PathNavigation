//
//  NavigationItem.swift
//

import Foundation

public struct PathNavigationItem<NavigatoinRoute>: Hashable where NavigatoinRoute: Hashable {
    public let itemID: String
    public let fragment: NavigatoinRoute
    public let transition: NavigationTransition

    public init(
        _ fragment: NavigatoinRoute,
        _ transition: NavigationTransition,
        itemID: String = UUID().uuidString
    ) {
        self.itemID = itemID
        self.fragment = fragment
        self.transition = transition
    }
}

public enum NavigationTransition: Codable, Hashable, Sendable {
    case overlay
    case alert
    case sheet
    case fullScreen
    case instant
    case transparent
    case push
    case root
    case noop
}
