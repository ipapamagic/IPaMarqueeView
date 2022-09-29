// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IPaMarqueeView",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "IPaMarqueeView",
            targets: ["IPaMarqueeView"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url:"https://github.com/ipapamagic/IPaUIKitHelper.git",from: "1.2.0") ,
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "IPaMarqueeView",
            dependencies: [.product(name: "IPaUIKitHelper", package: "IPaUIKitHelper")],
            resources: [
                        .process("IPaMarqueeContentView.xib")]),
        .testTarget(
            name: "IPaMarqueeViewTests",
            dependencies: ["IPaMarqueeView"]),
    ]
)
