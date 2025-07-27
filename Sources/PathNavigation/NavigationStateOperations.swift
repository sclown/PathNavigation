//
//  NavigationStateOperations.swift
//

import Foundation

extension PathNavigationState {
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
        updateFrameStates()
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
        updateFrameStates()
    }

    mutating func handleDismissed(stepID: String) {
        guard let index = (path.lastIndex { $0.itemID == stepID }) else { return }
        let count = path.count - index
        path.removeLast(count)
        updateFrameStates()
    }

    mutating func reset(to path: [PathNavigationItem<Route>]) {
        if let item = path.first {
            stack = PathStackFragments(
                root: item,
                pages: path.dropFirst().filter { $0.transition == .push }
            )
            self.path = path.dropFirst().filter { $0.transition != .push }
        }
        updateFrameStates()
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
        updateFrameStates()
    }

    mutating func updateFrameStates() {
//        let pathDescription = "\(stackFragments) \(fragments)"
//        Logger(for: .navigation).info("Navigation changed: \(pathDescription)")
        var items = [String: PathNavigationFrameState<Route>]()
        var nextStep: PathNavigationItem<Route>?
        for step in path.reversed() {
            var frameState = frameStates.removeValue(forKey: step.itemID)
                ?? PathNavigationFrameState(itemID: step.itemID)
            if nextStep == nil, frameState.next != nil {
                frameState.allowTransition = false
            }
            frameState.next = nextStep
            items[step.itemID] = frameState
            nextStep = step
        }
        if stack != nil {
            var frameState = frameStates.removeValue(forKey: rootID)
                ?? PathNavigationFrameState(itemID: rootID)
            if nextStep == nil, frameState.next != nil {
                frameState.allowTransition = false
            }
            frameState.next = nextStep
            items[rootID] = frameState
        }
        frameStates = items
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
