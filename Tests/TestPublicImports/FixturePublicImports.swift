import MockoloFramework

let basicProtocol = """
/// @mockable
protocol TestProtocol {
    func doSomething()
}
"""

let basicProtocolMockWithPublicImports = """

public import Combine
public import Foundation


class TestProtocolMock: TestProtocol {
    init() { }


    private(set) var doSomethingCallCount = 0
    var doSomethingHandler: (() -> ())?
    func doSomething() {
        doSomethingCallCount += 1
        if let doSomethingHandler = doSomethingHandler {
            doSomethingHandler()
        }
        
    }
}

"""

let protocolWithImports = """
import Foundation

/// @mockable
protocol ImportProtocol {
    func test()
}
"""

let protocolWithImportsAndPublicOverrides = """

public import Foundation
public import UIKit


class ImportProtocolMock: ImportProtocol {
    init() { }


    private(set) var testCallCount = 0
    var testHandler: (() -> ())?
    func test() {
        testCallCount += 1
        if let testHandler = testHandler {
            testHandler()
        }
        
    }
}

"""

let protocolWithMixedImports = """
import Charlie
import Echo

/// @mockable
protocol SortedProtocol {
    func sort()
}
"""

let sortedImportsOutput = """

@testable import Alpha
public import Beta
import Charlie
@testable import Delta
import Echo
public import Foxtrot


class SortedProtocolMock: SortedProtocol {
    init() { }


    private(set) var sortCallCount = 0
    var sortHandler: (() -> ())?
    func sort() {
        sortCallCount += 1
        if let sortHandler = sortHandler {
            sortHandler()
        }
        
    }
}

"""

let sourceWithPublicImport = """
public import UIKit

/// @mockable
public protocol UrlOpenerInput: AnyObject {
    func openUrl(_ url: URL)
}
"""

let mockWithPreservedPublicImport = """

public import UIKit


public class UrlOpenerInputMock: UrlOpenerInput {
    public init() { }


    public private(set) var openUrlCallCount = 0
    public var openUrlHandler: ((URL) -> ())?
    public func openUrl(_ url: URL) {
        openUrlCallCount += 1
        if let openUrlHandler = openUrlHandler {
            openUrlHandler(url)
        }
        
    }
}

"""