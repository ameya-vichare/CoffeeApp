// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoffeeModule",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CoffeeModule",
            targets: ["CoffeeModule"]
        ),
    ],
    dependencies: [
        .package(path: "../AppModels"),
        .package(path: "../Networking"),
        .package(path: "../AppEndpoints"),
        .package(path: "../AppConstants"),
        .package(path: "../AppUtils"),
        .package(path: "../DesignSystem"),
        .package(path: "../ImageLoading"),
        .package(path: "../Persistence"),
        .package(path: "../NetworkMonitoring")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CoffeeModule",
            dependencies: [
                "AppModels",
                "Networking",
                "AppEndpoints",
                "AppConstants",
                "AppUtils",
                "DesignSystem",
                "ImageLoading",
                "Persistence",
                "NetworkMonitoring"
            ]
        ),
        .testTarget(
            name: "CoffeeModuleTests",
            dependencies: ["CoffeeModule"]
        ),
    ]
)
