//
//  NavigationStateOperationsTests.swift
//  NavigationTests
//

import Testing
@testable import PathNavigation

struct NavigationStateOperationsTests {
    @Test func applyStack() {
        var state = PathNavigationState.longStack
        
        state.applyStack(path: [.details, .profile])
        
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
        state.reset(
            to: [.basic, .profileStack, .profileStack, .profile, .profile]
        )
        
        #expect(state.stackFragments == [.home, .profile, .profile])
        #expect(state.fragments == [.profile, .profile])
    }
    
    @Test func addBasic() {
        var state = PathNavigationState.basic
        
        state.add(item: .profile)
        
        #expect(state.fragments == [.home, .profile])
        #expect(state.stackFragments == [])
    }

    @Test func addToStack() {
        var state = PathNavigationState.basicStack
        
        state.add(item: .profileStack)
        
        #expect(state.path.count == 0)
        #expect(state.stackFragments == [.home, .profile])
    }

    @Test func addOverStack() {
        var state = PathNavigationState.basicStack
        
        state.add(item: .profile)
        
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
        state.add(item: .profile)
        
        let result = state.updateTop()
        
        #expect(result?.fragment == PathNavigationItem.profile.fragment)
    }
    
    @Test func updateTopInStack() {
        var state = PathNavigationState.basicStack
        state.add(item: .profileStack)
        
        let result = state.updateTop()

        #expect(result?.fragment == PathNavigationItem.profileStack.fragment)
    }
    
    @Test func updateTopWithNoChange() {
        var state = PathNavigationState.basicStack
        
        #expect(state.updateTop() == nil)
    }
}
