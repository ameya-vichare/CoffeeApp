// swift-tools-version: 5.9
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
        .package(path: "../../Core/AppCore"),
        .package(path: "../../Core/Networking"),
        .package(path: "../../Core/ImageLoading"),
        .package(path: "../../Core/Persistence"),
        .package(path: "../../Core/NetworkMonitoring"),
        .package(url: "https://github.com/nalexn/ViewInspector", from: "0.10.3")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CoffeeModule",
            dependencies: [
                "AppCore",
                "Networking",
                "ImageLoading",
                "Persistence",
                "NetworkMonitoring"
            ]
        ),
        .testTarget(
            name: "CoffeeModuleTests",
            dependencies: [
                "CoffeeModule",
                .product(name: "ViewInspector", package: "ViewInspector")
            ]
        ),
    ]
)
