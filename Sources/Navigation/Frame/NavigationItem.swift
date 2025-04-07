//
//  File.swift
//  Navigation
//
//  Created by Dmitry Kurkin on 11.04.25.
//

import Foundation

public struct PathNavigationItem: Hashable {
    public let itemID: String
    public let fragment: AnyHashable
    public let transition: NavigationTransition

    public init(
        _ fragment: AnyHashable,
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
