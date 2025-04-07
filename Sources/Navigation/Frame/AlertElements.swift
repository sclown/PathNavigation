//
//  File.swift
//  Navigation
//
//  Created by Dmitry Kurkin on 11.04.25.
//

import SwiftUI

@MainActor
public struct AlertElements {
    let buttons: AnyView
    let message: AnyView
    let title: String

    public init(
        title: String,
        buttons: AnyView,
        message: AnyView
    ) {
        self.title = title
        self.buttons = buttons
        self.message = message
    }

    public init(
        title: String,
        @ViewBuilder buttonsBuilder: () -> some View,
        @ViewBuilder messageBuilder: () -> some View
    ) {
        self.title = title
        buttons = AnyView(buttonsBuilder())
        message = AnyView(messageBuilder())
    }
}

public extension AlertElements {
    static var empty: Self {
        .init(
            title: "",
            buttons: AnyView(EmptyView()),
            message: AnyView(EmptyView())
        )
    }
}
