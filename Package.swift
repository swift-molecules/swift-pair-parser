// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-pair-parser",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Pair Parser",
            targets: ["Pair Parser"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-parser.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-pair.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-either.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Pair Parser",
            dependencies: [
                .product(name: "Parser", package: "swift-parser"),
                .product(name: "Pair", package: "swift-pair"),
                .product(name: "Either", package: "swift-either"),
            ]
        ),
        .testTarget(
            name: "Pair Parser Tests",
            dependencies: [
                .target(name: "Pair Parser"),
                .product(name: "Either", package: "swift-either"),
                .product(name: "Pair", package: "swift-pair"),
                .product(name: "Parser", package: "swift-parser"),
            ],
            path: "Tests/Pair Parser Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableExperimentalFeature("MoveOnlyTuples"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
