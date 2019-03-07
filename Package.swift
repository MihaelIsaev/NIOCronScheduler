// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "NIOCronScheduler",
    products: [
        .library(
            name: "NIOCronScheduler",
            targets: ["NIOCronScheduler"]),
    ],
    dependencies: [
        // Event-driven network application framework for high performance protocol servers & clients, non-blocking.
        .package(url: "https://github.com/apple/swift-nio.git", from: "1.12.0"),
        // ⏱ Simple pure swift cron expressions parser
        .package(url: "https://github.com/MihaelIsaev/SwifCron.git", from:"1.3.0"),
    ],
    targets: [
        .target(
            name: "NIOCronScheduler",
            dependencies: ["NIO", "SwifCron"]),
        .testTarget(
            name: "NIOCronSchedulerTests",
            dependencies: ["NIOCronScheduler"]),
    ]
)
