//
//  ViewFluxer.swift
//  FluxerKit-Demo
//
//  Created by Yuto Akiba on 2019/03/19.
//  Copyright © 2019 Yuto Akiba. All rights reserved.
//

import FluxerKit
import RxSwift

final class ViewFluxer: Fluxer {
    enum Action {
        case increase
        case decrease
    }

    enum Dispatcher {
        case increaseValue
        case decreaseValue
    }

    struct Store {
        let value = BehaviorSubject<Int>(value: 0)
    }

    let store: Store

    init() {
        self.store = Store()
    }

    func dispatch(action: Action) throws -> Observable<Dispatcher> {
        switch action {
        case .increase:
            return .just(.increaseValue)
        case .decrease:
            return .just(.decreaseValue)
        }
    }

    func updateStore(dispatcher: ViewFluxer.Dispatcher) throws {
        let value = try store.value.value()
        switch dispatcher {
        case .increaseValue:
            store.value.onNext(value + 1)
        case .decreaseValue:
            store.value.onNext(value - 1)
        }
    }
}
