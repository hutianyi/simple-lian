// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SimpleLianCore",
    platforms: [.macOS(.v15), .iOS("27.0")],
    products: [.library(name: "SimpleLianCore", targets: ["SimpleLianCore"])],
    targets: [
        .target(name: "SimpleLianCore"),
        .testTarget(name: "SimpleLianCoreTests", dependencies: ["SimpleLianCore"])
    ]
)
