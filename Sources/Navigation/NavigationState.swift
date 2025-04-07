//
//  File.swift
//  Navigation
//
//  Created by Dmitry Kurkin on 11.04.25.
//

import Foundation

struct PathNavigationState {
    var path: [PathNavigationItem]
    var stack: PathStackFragments?
    let rootID: String
    var lastItems = [String: PathNavigationFrameState]()
    var top: PathNavigationItem?

    init(root: AnyHashable) {
        let item = PathNavigationItem(root, .root)
        self.init(path: [item], stack: nil)
    }

    init(stack root: AnyHashable) {
        let item = PathNavigationItem(root, .root)
        self.init(path: [], stack: PathStackFragments(root: item, pages: []))
    }

    init(
        path: [PathNavigationItem] = [],
        stack: PathStackFragments? = .dashboard
    ) {
        self.path = path
        self.stack = stack
        rootID = "root"
        updateLastItems()
        top = path.last ?? stack?.root
    }
}

public struct PathStackFragments: Hashable {
    public let root: PathNavigationItem
    public var pages: [PathNavigationItem]

    public static var dashboard: Self {
        PathStackFragments(
            root: PathNavigationItem(
                "",
                .root
            ),
            pages: []
        )
    }
}

