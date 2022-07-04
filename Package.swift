// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "NIOCronScheduler",
    products: [
        .library(name: "NIOCronScheduler", targets: ["NIOCronScheduler"]),
    ],
    dependencies: [
        // Event-driven network application framework for high performance protocol servers & clients, non-blocking.
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.10.0"),
        // ⏱ Simple pure swift cron expressions parser
        .package(url: "https://github.com/MihaelIsaev/SwifCron.git", from: "2.0.0"),
    ],
    targets: [
        .target(name: "NIOCronScheduler", dependencies: ["NIO", "SwifCron"]),
        .testTarget(name: "NIOCronSchedulerTests", dependencies: ["NIOCronScheduler"]),
    ]
)
