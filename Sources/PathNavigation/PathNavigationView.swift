//
//  PathNavigationView.swift
//

import SwiftUI

public struct PathNavigationView<Content, NavigationRoute>: View where Content: View, NavigationRoute: Hashable {
    @ObservedObject var viewModel: NavigationViewModel<NavigationRoute>
    let destinations: (NavigationRoute) -> Content
    let alerts: (NavigationRoute) -> AlertElements

    public init(
        viewModel: NavigationViewModel<NavigationRoute>,
        destinations: @escaping (NavigationRoute) -> Content,
        alerts: @escaping (NavigationRoute) -> AlertElements = { _ in noAlerts }
    ) {
        self.viewModel = viewModel
        self.destinations = destinations
        self.alerts = alerts
    }

    public var body: some View {
        chain()
    }

    private func chain() -> AnyView? {
        let state = viewModel.state
        var nextContent: AnyView?
        var alertInfo: AlertElements?
        for step in state.path.reversed() {
            if step.transition == .alert {
                alertInfo = alerts(step.fragment)
            } else {
                let frame = navigationFrame(
                    for: destinations(step.fragment),
                    nextContent: nextContent,
                    alertContent: alertInfo,
                    stepID: step.itemID
                )
                nextContent = AnyView(frame)
                alertInfo = nil
            }
        }
        if let stack = state.stack {
            let stackView = PathNavigationStack(
                root: stack.root,
                stackBinding: Binding(
                    get: { stack.pages },
                    set: { viewModel.replaceStackPath($0) }
                ),
                destinations: { destinations($0) }
            )
            let frame = navigationFrame(
                for: stackView,
                nextContent: nextContent,
                alertContent: alertInfo,
                stepID: state.rootID
            )
            return AnyView(frame)
        }
        return nextContent
    }

    private func navigationFrame(
        for content: some View,
        nextContent: AnyView?,
        alertContent: AlertElements? = nil,
        stepID: String
    ) -> some View {
        guard let state = (viewModel.state).frameStates[stepID] else {
            preconditionFailure("PathNavigation: No state for step \(stepID)")
        }
        return PathNavigationFrame(
            content: content,
            nextContent: nextContent,
            alertContent: alertContent,
            state: state,
            finishTransition: {
                viewModel.allowTransition(for: state.itemID)
            },
            onDismiss: {
                viewModel.removeLast(stepID: state.next?.itemID)
            }
        )
    }
}

@MainActor
public var noAlerts: AlertElements {
    AlertElements(
        title: "No alerts expected",
        buttons: AnyView(EmptyView()),
        message: AnyView(EmptyView())
    )
}
