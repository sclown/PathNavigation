import Testing
@testable import Navigation

@Test func topStack() async throws {
    let state = PathNavigationState(
        stack: PathStackFragments(
            root: "root",
            pages: ["page1", "page2"]
        )
    )
    state.updateTop()
    #expect(state.top?.fragment == "page2")
}
