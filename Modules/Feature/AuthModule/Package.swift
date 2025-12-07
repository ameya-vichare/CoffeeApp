// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AuthModule",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AuthModule",
            targets: ["AuthModule"]
        ),
    ],
    dependencies: [
        .package(path: "../../Core/AppCore"),
        .package(path: "../../Core/Networking"),
        .package(path: "../../Core/Persistence")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AuthModule",
            dependencies: [
                "AppCore",
                "Networking",
                "Persistence"
            ]
        ),
        .testTarget(
            name: "AuthModuleTests",
            dependencies: ["AuthModule"]
        ),
    ]
)
