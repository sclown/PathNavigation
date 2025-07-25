// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Navigation",
    platforms: [.iOS("16.0")],
    products: [
        .library(name: "Navigation", targets: ["Navigation"]),
        .library(name: "InputRequest", targets: ["InputRequest"]), // requires iOS 18
        .library(name: "InputRequestCombine", targets: ["InputRequestCombine"])
    ],
    targets: [
        .target(name: "Navigation"),
        .target(name: "InputRequest", dependencies: ["Navigation"]),
        .target(name: "InputRequestCombine", dependencies: ["Navigation"])
    ]
)
