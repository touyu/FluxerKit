//
//  ActionSubject.swift
//  FluxerKit
//
//  Created by Yuto Akiba on 2019/03/19.
//  Copyright © 2019 Yuto Akiba. All rights reserved.
//

import class Foundation.NSLock.NSRecursiveLock

import RxSwift

public final class ActionSubject<Element>: ObservableType, ObserverType, SubjectType {
    public typealias E = Element
    typealias Key = UInt

    private let _lock = RecursiveLock()
    private var _observers: [Key: (Event<Element>) -> ()] = [:]
    private var _nextKey: Key = 0

    public func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.E == Element {
        self._lock.lock()
        let subscription = self._synchronized_subscribe(observer)
        self._lock.unlock()
        return subscription
    }

    func _synchronized_subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.E == E {
        self._nextKey += 1
        let key = self._nextKey
        self._observers[key] = observer.on
        return Disposables.create { [weak self] in
            self?._lock.lock()
            self?._observers.removeValue(forKey: key)
            self?._lock.unlock()
        }
    }

    public func on(_ event: Event<Element>) {
        self._lock.lock(); defer { self._lock.unlock() }
        if case .next = event {
            self._observers.values.forEach { $0(event) }
        }
    }
}

