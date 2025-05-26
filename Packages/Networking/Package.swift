// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "Networking",
    defaultLocalization: "en",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "Networking",
            targets: ["Networking"]
        ),
    ],
    dependencies: [
        .package(name: "Library", path: "../Library")
    ],
    targets: [
        .target(
            name: "Networking",
            dependencies: ["Library"],
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"],
            resources: [.process("MockData")]
        ),
    ]
)
