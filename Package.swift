// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlisterSwift",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "AlisterSwift",
            targets: ["AlisterSwift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Quick/Nimble", .upToNextMajor(from: "8.0.7")),
        .package(url: "https://github.com/Quick/Quick", .upToNextMajor(from: "2.2.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "AlisterSwift",
            dependencies: []),
        .testTarget(
            name: "AlisterSwiftTests",
            dependencies: ["AlisterSwift", "Nimble", "Quick"]),
    ],
    swiftLanguageVersions: [.v5]
)
