//
//  File.swift
//  Navigation
//
//  Created by Dmitry Kurkin on 11.04.25.
//

import Foundation

class PathNavigationFrameState: ObservableObject, Equatable {
    let itemID: String
    var next: PathNavigationItem?
    var allowTransition = false

    init(
        itemID: String,
        next: PathNavigationItem? = nil,
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
