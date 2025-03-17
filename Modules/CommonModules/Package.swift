// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let targets: [PackageDescription.Target] = [
    .target(name: "PixabayAPI"),
]

let package = Package(
    name: "CommonModules",
    platforms: [.iOS(.v15)],
    products: targets
        .map { target -> PackageDescription.Product in
            .library(name: target.name, targets: [target.name])
        },

    targets: targets
)
