//
//  NavigationFrameState.swift
//

import Foundation

class PathNavigationFrameState<NavigationRoute: Hashable>: ObservableObject, Equatable {
    let itemID: String
    var next: PathNavigationItem<NavigationRoute>?
    var allowTransition = false

    init(
        itemID: String,
        next: PathNavigationItem<NavigationRoute>? = nil,
        allowTransition: Bool = false
    ) {
        self.itemID = itemID
        self.next = next
        self.allowTransition = allowTransition
    }

    static func == (
        lhs: PathNavigationFrameState,
        rhs: PathNavigationFrameState
    ) -> Bool {
        lhs.itemID == rhs.itemID
    }

}
