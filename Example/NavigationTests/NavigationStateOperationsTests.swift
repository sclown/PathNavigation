//
//  NavigationStateOperationsTests.swift
//  NavigationTests
//

import Testing
@testable import Navigation

struct NavigationStateOperationsTests {
    @Test func applyStack() {
        var state = PathNavigationState.longStack
        
        state.applyStack(path: [.details, .second])
        
        #expect(state.stackFragments == [.home, .detail, .profile])
    }
    
    @Test func removeLastEmpty() {
        var state = PathNavigationState<TestRoute>()
        state.removeLast()
        #expect(state.stackFragments == [])
        #expect(state.fragments == [])
    }

    @Test func removeLastFromPath() {
        var state = PathNavigationState.long
        state.removeLast()
        #expect(state.fragments == [.home, .profile])
    }


    @Test func removeLastFromStack() {
        var state = PathNavigationState.longStack
        state.removeLast()
        #expect(state.stackFragments == [.home, .profile])
    }

    @Test func removeLastAfterStack() {
        var state = PathNavigationState.longStackMore
        state.removeLast()
        #expect(state.stackFragments == [.home, .profile, .detail])
    }
    
    @Test func handleDismissedInvalid() {
        var state = PathNavigationState.long
        
        state.handleDismissed(stepID: "unknown-id")
        
        #expect(state.fragments == [.home, .profile, .detail])
    }

    @Test func handleDismissed() {
        var state = PathNavigationState.long
        
        state.handleDismissed(stepID: state.path.last!.itemID)
        
        #expect(state.fragments == [.home, .profile])
    }
    
    @Test func reset() {
        var state = PathNavigationState.basic
        state.reset(to: [.basic, .secondStack, .secondStack, .second, .second])
        
        #expect(state.stackFragments == [.home, .profile, .profile])
        #expect(state.fragments == [.profile, .profile])
    }
    
    @Test func addBasic() {
        var state = PathNavigationState.basic
        
        state.add(item: .second)
        
        #expect(state.fragments == [.home, .profile])
        #expect(state.stackFragments == [])
    }

    @Test func addToStack() {
        var state = PathNavigationState.basicStack
        
        state.add(item: .secondStack)
        
        #expect(state.path.count == 0)
        #expect(state.stackFragments == [.home, .profile])
    }

    @Test func addOverStack() {
        var state = PathNavigationState.basicStack
        
        state.add(item: .second)
        
        #expect(state.stackFragments == [.home])
        #expect(state.fragments == [.profile])
    }
    
    @Test func addSecondOverlay() {
        var state = PathNavigationState.withOverlay
        
        state.add(item: .secondOverlay)
        #expect(state.fragments == [.home, .settings])
        #expect(state.stackFragments == [])
    }

    
    @Test func updateTop() {
        var state = PathNavigationState.basic
        state.add(item: .second)
        
        let result = state.updateTop()
        
        #expect(result?.fragment == PathNavigationItem.second.fragment)
    }
    
    @Test func updateTopInStack() {
        var state = PathNavigationState.basicStack
        state.add(item: .secondStack)
        
        let result = state.updateTop()

        #expect(result?.fragment == PathNavigationItem.secondStack.fragment)
    }
    
    @Test func updateTopWithNoChange() {
        var state = PathNavigationState.basicStack
        
        #expect(state.updateTop() == nil)
    }
}

enum TestRoute: Hashable {
    case home, profile, settings, detail
}

extension PathNavigationItem<TestRoute> {
    static var basic: Self {
        .init(TestRoute.home, .root)
    }
    
    static var second: Self {
        .init(.profile, .sheet)
    }
    
    static var details: Self {
        .init(.detail, .fullScreen)
    }
    
    static var secondStack: Self {
        .init(.profile, .push)
    }
    
    static var overlay: Self {
        .init(.profile, .overlay)
    }
    
    static var secondOverlay: Self {
        .init(.settings, .overlay)
    }
}

extension PathNavigationState<TestRoute> {
    static var basic: Self {
        .init(path: [.basic])
    }
    
    static var long: Self {
        .init(path: [.basic, .second, .details])
    }
    
    static var longStack: Self {
        .init(
            stack: PathStackFragments(
                root: .basic,
                pages: [.second, .details]
            )
        )
    }

    static var longStackMore: Self {
        .init(
            path: [.second],
            stack: PathStackFragments(
                root: .basic,
                pages: [.second, .details]
            )
        )
    }
    
    static var basicStack: Self {
        .init(stack: .home)
    }
    
    static var withOverlay: Self {
        .init(path: [.basic, .overlay])
    }
}
