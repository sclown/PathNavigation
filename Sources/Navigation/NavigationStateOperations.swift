//
//  NavigationStateOperations.swift
//

import Foundation

extension PathNavigationState {
    func last() -> PathNavigationItem<Route>? {
        if let last = path.last {
            return last
        }
        if let last = stack?.pages.last {
            return last
        }
        return stack?.root
    }

    var stackFragments: [Route] {
        stack.map { stackValue in
            [stackValue.root.fragment] + stackValue.pages.map(\.fragment)
        } ?? []
    }

    var fragments: [Route] {
        path.map(\.fragment)
    }

    mutating func applyStack(path: [PathNavigationItem<Route>]) {
        stack?.pages = path
        updateLastItems()
    }

    mutating func removeLast() {
        guard stack != nil || path.count > 1 else { return }
        if path.isEmpty {
            if stack?.pages.isEmpty == false {
                stack?.pages.removeLast()
            }
        } else {
            path.removeLast()
        }
        updateLastItems()
    }

    mutating func handleDismissed(stepID: String) {
        guard let index = (path.lastIndex { $0.itemID == stepID }) else { return }
        let count = path.count - index
        path.removeLast(count)
        updateLastItems()
    }

    mutating func reset(to path: [PathNavigationItem<Route>]) {
        if let item = path.first {
            stack = PathStackFragments(
                root: item,
                pages: path.dropFirst().filter { $0.transition == .push }
            )
            self.path = path.dropFirst().filter { $0.transition != .push }
        }
        updateLastItems()
    }

    mutating func add(item: PathNavigationItem<Route>) {
        if item.transition == .push {
            stack?.pages.append(item)
        } else {
            if path.last?.transition == .overlay {
                path.removeLast()
            }
            path.append(item)
        }
        updateLastItems()
    }

    mutating func updateLastItems() {
//        let pathDescription = "\(stackFragments) \(fragments)"
//        Logger(for: .navigation).info("Navigation changed: \(pathDescription)")
        var items = [String: PathNavigationFrameState<Route>]()
        var nextStep: PathNavigationItem<Route>?
        for step in path.reversed() {
            var item = lastItems.removeValue(forKey: step.itemID)
                ?? PathNavigationFrameState(itemID: step.itemID)
            if nextStep == nil, item.next != nil {
                item.allowTransition = false
            }
            item.next = nextStep
            items[step.itemID] = item
            nextStep = step
        }
        if stack != nil {
            var item = lastItems.removeValue(forKey: rootID)
                ?? PathNavigationFrameState(itemID: rootID)
            if nextStep == nil, item.next != nil {
                item.allowTransition = false
            }
            item.next = nextStep
            items[rootID] = item
        }
        lastItems = items
    }

    mutating func updateTop() -> PathNavigationItem<Route>? {
        let lastStep = path.last
            ?? stack?.pages.last
            ?? stack?.root
        if lastStep != top {
            top = lastStep
            return top
        }
        return nil
    }
}
