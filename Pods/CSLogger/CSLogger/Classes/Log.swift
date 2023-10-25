
import XCGLogger

/*
 case verbose
 case debug
 case info
 case notice
 case warning
 case error
 case severe // aka critical
 case alert
 case emergency
 case none
 */
public let logger: XCGLogger = {
    let log = XCGLogger.default
    log.setup(level: .verbose, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true)
    return log
}()
