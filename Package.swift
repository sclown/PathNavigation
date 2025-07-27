// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PathNavigation",
    platforms: [.iOS("16.0")],
    products: [
        .library(name: "PathNavigation", targets: ["PathNavigation"]),
        .library(name: "PNInputRequest", targets: ["PNInputRequest"]), // requires iOS 18
        .library(name: "PNInputRequestCombine", targets: ["PNInputRequestCombine"])
    ],
    targets: [
        .target(name: "PathNavigation"),
        .target(name: "PNInputRequest", dependencies: ["PathNavigation"]),
        .target(name: "PNInputRequestCombine", dependencies: ["PathNavigation"])
    ]
)
