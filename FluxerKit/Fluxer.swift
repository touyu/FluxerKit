//
//  Fluxer.swift
//  FluxerKit
//
//  Created by Yuto Akiba on 2019/03/19.
//  Copyright © 2019 Yuto Akiba. All rights reserved.
//

import RxSwift

public protocol Fluxer: class, AssociatedObjectStore {
    associatedtype Action
    associatedtype Dispatcher = Action
    associatedtype Store

    var store: Store { get }

    func transform(action: Observable<Action>) -> Observable<Action>
    func dispatch(action: Action) throws -> Observable<Dispatcher>
    func transform(dispatcher: Observable<Dispatcher>) -> Observable<Dispatcher>
    func updateStore(dispatcher: Dispatcher) throws
    func transform(store: Store)
}

private var actionKey = "action"
private var disposeBagKey = "disposeBag"
private var alreadyRegisteredKey = "alreadyRegistered"

extension Fluxer {
    fileprivate var disposeBag: DisposeBag {
        get { return self.associatedObject(forKey: &disposeBagKey, default: DisposeBag()) }
    }

    private var _action: ActionSubject<Action> {
        return self.associatedObject(forKey: &actionKey, default: .init())
    }

    private var _alreadyRegistered: Bool {
        get {
            return self.associatedObject(forKey: &alreadyRegisteredKey, default: false)
        }
        set {
            self.setAssociatedObject(newValue, forKey: &alreadyRegisteredKey)
        }
    }

    public var action: ActionSubject<Action> {
        if !_alreadyRegistered {
            registerFluxStream()
        }

        return self._action
    }

    public func transform(action: Observable<Action>) -> Observable<Action> {
        return action
    }

    public func dispatch(action: Action) throws -> Observable<Dispatcher> {
        return .empty()
    }

    public func transform(dispatcher: Observable<Dispatcher>) -> Observable<Dispatcher> {
        return dispatcher
    }

    public func updateStore(dispatcher: Dispatcher) throws {

    }

    public func transform(store: Store) {

    }

    func registerFluxStream() {
        defer {
            _alreadyRegistered = true
        }

        let transformedAction = transform(action: _action.asObservable())
        let dispatcher = transformedAction
            .flatMap { [weak self] action -> Observable<Dispatcher> in
                guard let self = self else { return .empty() }
                do {
                    return try self.dispatch(action: action).catchError { _ in .empty() }
                } catch {
                    return .empty()
                }
            }
        let transformedDispatcher = transform(dispatcher: dispatcher)
        let stream = transformedDispatcher
            .do(onNext: { [weak self] dispatcher in
                guard let self = self else { return }
                do {
                    try self.updateStore(dispatcher: dispatcher)
                    self.transform(store: self.store)
                } catch {
                    return
                }
            }).replay(1)

        stream.connect().disposed(by: disposeBag)
    }
}

