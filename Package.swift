// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MacSettings",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(name: "MacSettings", targets: ["MacSettings"])
    ],
    targets: [
        .target(name: "MacSettings", dependencies: [], exclude: ["Demo", "Resources"]),
        .testTarget(name: "MacSettingsTests", dependencies: ["MacSettings"], exclude: ["Demo", "Resources"])
    ]
)
