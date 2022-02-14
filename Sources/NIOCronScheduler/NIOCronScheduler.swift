import Foundation
import NIO
import SwifCron

public class NIOCronScheduler {
    @discardableResult
    public static func schedule<T: NIOCronFutureSchedulable>(_ job: T.Type, on eventLoop: EventLoop) throws -> NIOCronJob {
        return try schedule(job.expression, on: eventLoop) { job.task(on: eventLoop) }
    }
    
    @discardableResult
    public static func schedule(_ job: NIOCronSchedulable.Type, on eventLoop: EventLoop) throws -> NIOCronJob {
        return try schedule(job.expression, on: eventLoop) { job.task() }
    }
    
    @discardableResult
    public static func schedule<N: NIOCronGenericSchedulable>(_ job: N.Type, on container: N.Container) throws -> NIOCronJob {
        return try schedule(job.expression, on: container.eventLoop) { job.task(on: container) }
    }
    
    @discardableResult
    public static func schedule(_ expression: String, on eventLoop: EventLoop, _ task: @escaping () throws -> Void) throws -> NIOCronJob {
        return try schedule(expression: expression, on: eventLoop, task: task, offset: 1)
    }
    
    @discardableResult
    private static func schedule(expression: String, on eventLoop: EventLoop, task: @escaping () throws -> Void, offset: TimeInterval) throws -> NIOCronJob {
        let cron = try SwifCron(expression)
        let nextDate = try cron.next(from: Date(timeIntervalSinceNow: offset))
        let secondsTo = nextDate.timeIntervalSince1970 - Date().timeIntervalSince1970 + 1
        let job = NIOCronJob()
        let task = eventLoop.scheduleTask(in: .seconds(Int64(secondsTo))) {
            job.onCancel = try self.schedule(expression: expression, on: eventLoop, task: task, offset: 1).cancel
            try task()
        }
        job.onCancel = task.cancel
        return job
    }
}

public protocol NIOCronExpressable {
    static var expression: String { get }
}

public protocol NIOCronEventLoopable {
    var eventLoop: EventLoop { get }
}

public class NIOCronJob {
    init () {}
    fileprivate var onCancel: () -> Void = {}
    public func cancel() { onCancel() }
}

public protocol NIOCronSchedulable: NIOCronExpressable {
    static func task()
}

public protocol NIOCronFutureSchedulable: NIOCronExpressable {
    associatedtype T
    
    @discardableResult
    static func task(on eventLoop: EventLoop) -> EventLoopFuture<T>
}

public protocol NIOCronGenericSchedulable: NIOCronExpressable {
    associatedtype Container: NIOCronEventLoopable
    associatedtype Result
    
    @discardableResult
    static func task(on container: Container) -> EventLoopFuture<Result>
}
