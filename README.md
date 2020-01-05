[![Mihael Isaev](https://user-images.githubusercontent.com/1272610/53929077-f5da0b80-40a5-11e9-9992-d79cf212125e.png)](http://mihaelisaev.com)

<p align="center">
    <a href="LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/swift-5.1-brightgreen.svg" alt="Swift 5.1">
    </a>
</p>

<br>

### Don't forget to support the lib by giving a ⭐️

Built for NIO2

> 💡NIO1 version is available in `nio1` branch and from `1.0.0` tag

## How to install

### Swift Package Manager

```swift
.package(url: "https://github.com/MihaelIsaev/NIOCronScheduler.git", from:"2.0.0")
```
In your target's dependencies add `"NIOCronScheduler"` e.g. like this:
```swift
.target(name: "App", dependencies: ["NIOCronScheduler"]),
```

## Usage

```swift
import NIOCronScheduler

/// Simplest way is to use closure
let job = try? NIOCronScheduler.schedule("* * * * *", on: eventLoop) {
    print("Closure fired")
}

/// Or create a struct that conforms to NIOCronSchedulable
struct Job1: NIOCronSchedulable {
    static var expression: String { return "* * * * *" }

    static func task() {
        print("Job1 fired")
    }
}
let job1 = try? NIOCronScheduler.schedule(Job1.self, on: eventLoop)

/// Or create a struct that conforms to NIOCronFutureSchedulable
/// to be able to return a future
struct Job2: NIOCronFutureSchedulable {
    static var expression: String { return "*/2 * * * *" }

    static func task(on eventLoop: EventLoop) -> EventLoopFuture<Void> { //Void is not a requirement, you may return any type
        return eventLoop.newSucceededFuture(result: ()).always {
            print("Job2 fired")
        }
    }
}
let job2 = try? NIOCronScheduler.schedule(Job2.self, on: eventLoop)
```

Scheduled job may be cancelled just by calling `.cancel()` on it

#### For Vapor users

The easiest way is to define all cron jobs in `configure.swift`

So it may look like this
```swift
import Vapor
import NIOCronScheduler

// Called before your application initializes.
func configure(_ app: Application) throws {
    // ...

    let job = try? NIOCronScheduler.schedule("* * * * *", on: app.eventLoopGroup.next()) {
        print("Closure fired")
    }
    /// This example code will cancel scheduled job after 185 seconds
    /// so in a console you'll see "Closure fired" three times only
    app.eventLoopGroup.next().scheduleTask(in: .seconds(185)) {
        job?.cancel()
    }
}
```
Or sure you could schedule something from `req: Request` cause it have `eventLoopGroup.next()` inside itself as well.

## Limitations

Cron expression parsing works through [SwifCron](https://github.com/MihaelIsaev/SwifCron) lib, please read it limitations and feel free to contribute into this lib as well

## Contributing

Please feel free to contribute!
