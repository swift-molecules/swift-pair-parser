// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-parser-pair",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Parser Pair",
            targets: ["Parser Pair"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-parser.git",
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
            name: "Parser Pair",
            dependencies: [
                .product(name: "Parser", package: "swift-parser"),
                .product(name: "Pair", package: "swift-pair"),
                .product(name: "Either", package: "swift-either"),
            ]
        ),
        .testTarget(
            name: "Parser Pair Tests",
            dependencies: ["Parser Pair"],
            path: "Tests/Parser Pair Tests"
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
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
