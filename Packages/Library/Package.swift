// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Library",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Library",
            targets: ["Library"]
        ),
    ],
    targets: [
        .target(
            name: "Library"),
        .testTarget(
            name: "LibraryTests",
            dependencies: ["Library"]
        ),
    ]
)
