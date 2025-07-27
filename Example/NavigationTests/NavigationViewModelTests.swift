//
//  NavigationViewModelTests.swift
//  NavigationTests
//

import Testing
@testable import PathNavigation

struct NavigationViewModelTests {
    
    @Test func present() {
        var topChanged: TestRoute?
        let viewModel = NavigationViewModel(root: TestRoute.home) { route in
            topChanged = route
        }
        
        viewModel.present(.profile, transition: .sheet)
        
        #expect(viewModel.state.fragments == [.home, .profile])
        #expect(topChanged == .profile)
    }
    
    @Test func dismiss() {
        var topChanged: TestRoute?
        let viewModel = NavigationViewModel(state: .long) {
            topChanged = $0
        }
        
        viewModel.dismiss()
        
        #expect(viewModel.state.fragments == [.home, .profile])
        #expect(topChanged == .profile)
    }
    
    @Test func allowTransition() {
        let viewModel = NavigationViewModel(root: TestRoute.home)
        viewModel.present(.profile, transition: .sheet)
        let itemID = viewModel.state.path.last!.itemID
        
        viewModel.allowTransition(for: itemID)
        
        #expect(viewModel.state.frameStates[itemID]?.allowTransition == true)
    }
    
    @Test func removeLastWithStepID() {
        var topChanged: TestRoute?
        let viewModel = NavigationViewModel(state: .long) { route in
            topChanged = route
        }
        let stepID = viewModel.state.path.last?.itemID
        
        viewModel.removeLast(stepID: stepID)
        
        #expect(viewModel.state.fragments == [.home, .profile])
        #expect(topChanged == .profile)
    }
    
    @Test func removeLastWithInvalidStepID() {
        let viewModel = NavigationViewModel(state: .long)
        
        viewModel.removeLast(stepID: "invalid")
        
        #expect(viewModel.state.fragments == [.home, .profile, .detail])
    }
    
    @Test func replace() {
        var topChanged: TestRoute?
        let viewModel = NavigationViewModel(root: TestRoute.home) { route in
            topChanged = route
        }
        
        viewModel.replace(
            stack: [.profile, .settings],
            path: [(.detail, .sheet)]
        )
        
        #expect(viewModel.state.stackFragments == [.profile, .settings])
        #expect(viewModel.state.fragments == [.detail])
        #expect(topChanged == .detail)
    }
    
    @Test func replaceEmptyStack() {
        let viewModel = NavigationViewModel(stack: TestRoute.home)
        
        viewModel.replace(stack: [], path: [(.profile, .sheet)])
        
        #expect(viewModel.state.fragments == [.profile])
    }
    
    @Test func replacePath() {
        var topChanged: TestRoute?
        let viewModel = NavigationViewModel(root: TestRoute.home) { route in
            topChanged = route
        }
        
        viewModel.replacePath([.profile, .detail, .settings]) { route in
            switch route {
            case .profile: return .push
            case .settings: return .sheet
            default: return nil
            }
        }
        
        #expect(viewModel.state.stackFragments == [.profile])
        #expect(viewModel.state.fragments == [.settings])
        #expect(topChanged == .settings)
    }
    
    @Test func replaceStackPath() {
        let viewModel = NavigationViewModel(state: .basicStack)
        
        viewModel.replaceStackPath([.profileStack, .details])
        
        #expect(viewModel.state.stackFragments == [.home, .profile, .detail])
    }
}
