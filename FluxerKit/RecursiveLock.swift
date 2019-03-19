//
//  RecursiveLock.swift
//  FluxerKit
//
//  Created by Yuto Akiba on 2019/03/19.
//  Copyright © 2019 Yuto Akiba. All rights reserved.
//

import class Foundation.NSRecursiveLock

#if TRACE_RESOURCES
class RecursiveLock: NSRecursiveLock {
    override init() {
        _ = Resources.incrementTotal()
        super.init()
    }

    override func lock() {
        super.lock()
        _ = Resources.incrementTotal()
    }

    override func unlock() {
        super.unlock()
        _ = Resources.decrementTotal()
    }

    deinit {
        _ = Resources.decrementTotal()
    }
}
#else
typealias RecursiveLock = NSRecursiveLock
#endif
