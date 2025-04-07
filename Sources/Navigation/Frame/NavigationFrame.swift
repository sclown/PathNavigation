//
//  File.swift
//  Navigation
//
//  Created by Dmitry Kurkin on 11.04.25.
//

import SwiftUI

struct PathNavigationFrame<Content>: View where Content: View {
    let content: Content
    let nextContent: AnyView?
    let alertContent: AlertElements?
    let state: PathNavigationFrameState
    let finishTransition: () -> Void
    let onDismiss: () -> Void

    init(
        content: Content,
        nextContent: AnyView?,
        alertContent: AlertElements?,
        state: PathNavigationFrameState,
        finishTransition: @escaping () -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self.content = content
        self.nextContent = nextContent
        self.alertContent = alertContent
        self.state = state
        self.finishTransition = finishTransition
        self.onDismiss = onDismiss
    }

    var body: some View {
        content
            .sheet(
                isPresented: sheetBinding,
                onDismiss: { finishTransition() },
                content: { nextContent }
            )
            .fullScreenCover(
                isPresented: presentBinding,
                onDismiss: { finishTransition() },
                content: { nextContent }
            )
//            .transparentFullScreenCover(
//                isPresented: transparentBinding,
//                animated: true,
//                onDismiss: { finishTransition() },
//                content: { nextContent }
//            )
//            .transparentFullScreenCover(
//                isPresented: instantBinding,
//                animated: false,
//                onDismiss: { finishTransition() },
//                content: { nextContent }
//            )
            .alert(
                alertContent?.title ?? "",
                isPresented: alertBinding,
                actions: {
                    AnyView(
                        alertContent?.buttons
                            .onDisappear {
                                finishTransition()
                            }
                    )
                },
                message: { alertContent?.message }
            )
            .background {
                AnimationDelay {
                    finishTransition()
                }
            }
            .overlay {
                if showOverlay {
                    nextContent?.onDisappear { finishTransition() }
                }
            }
    }

    var showSheet: Bool {
        nextContent != nil
            && state.next?.transition == .sheet
            && state.allowTransition
    }

    var sheetBinding: Binding<Bool> {
        Binding(
            get: { showSheet },
            set: { if $0 == false { onDismiss() } }
        )
    }

    var showFullScreen: Bool {
        nextContent != nil
            && state.next?.transition == .fullScreen
            && state.allowTransition
    }

    var presentBinding: Binding<Bool> {
        Binding(
            get: { showFullScreen },
            set: { if $0 == false { onDismiss() } }
        )
    }

    var showTransparent: Bool {
        nextContent != nil
            && state.next?.transition == .transparent
            && state.allowTransition
    }

    var transparentBinding: Binding<Bool> {
        Binding(
            get: { showTransparent },
            set: { if $0 == false { onDismiss() } }
        )
    }

    var showInstant: Bool {
        nextContent != nil
            && state.next?.transition == .instant
            && state.allowTransition
    }

    var instantBinding: Binding<Bool> {
        Binding(
            get: { showInstant },
            set: { if $0 == false { onDismiss() } }
        )
    }

    var showOverlay: Bool {
        nextContent != nil && state.next?.transition == .overlay
    }

    var showAlert: Bool {
        alertContent != nil
            && state.next?.transition == .alert
            && state.allowTransition
    }

    var alertBinding: Binding<Bool> {
        Binding(
            get: { showAlert },
            set: {
                if $0 == false {
                    onDismiss()
                }
            }
        )
    }
}

struct AnimationDelay: View {
    var action: () -> Void

    var body: some View {
        EmptyView()
            .task {
                try? await Task.sleep(
                    for: .seconds(CATransaction.animationDuration())
                )
                action()
            }
    }
}
