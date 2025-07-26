//
//  NavigationStates.swift
//

@testable import Navigation

enum TestRoute: Hashable {
    case home, profile, settings, detail
}

extension PathNavigationItem<TestRoute> {
    static var basic: Self {
        .init(TestRoute.home, .root)
    }
    
    static var profile: Self {
        .init(.profile, .sheet)
    }
    
    static var details: Self {
        .init(.detail, .fullScreen)
    }
    
    static var profileStack: Self {
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
        .init(path: [.basic, .profile, .details])
    }
    
    static var longStack: Self {
        .init(
            stack: PathStackFragments(
                root: .basic,
                pages: [.profile, .details]
            )
        )
    }

    static var longStackMore: Self {
        .init(
            path: [.profile],
            stack: PathStackFragments(
                root: .basic,
                pages: [.profile, .details]
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
