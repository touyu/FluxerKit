//
//  FluxerStoryboardBindable.swift
//  FluxerKit
//
//  Created by Yuto Akiba on 2019/03/19.
//  Copyright © 2019 Yuto Akiba. All rights reserved.
//

import RxSwift
import RxCocoa

public protocol FluxerStoryboardBindable: FluxerBindable {}

extension FluxerStoryboardBindable where Self: UIViewController {
    public var fluxer: Fluxer? {
        get { return self.associatedObject(forKey: &fluxerKey) }
        set {
            self.setAssociatedObject(newValue, forKey: &fluxerKey)
            self.isReactorBinded = false
            self.disposeBag = DisposeBag()
            self.invokedViewDidLoad()
        }
    }

    private var isReactorBinded: Bool {
        get { return self.associatedObject(forKey: &isReactorBindedKey, default: false) }
        set { self.setAssociatedObject(newValue, forKey: &isReactorBindedKey) }
    }

    private func performBinding() {
        guard let fluxer = self.fluxer else { return }
        guard !self.isReactorBinded else { return }
        guard self.isViewLoaded else { return }

        self.bind(fluxer: fluxer)
        self.isReactorBinded = true
    }

    private func invokedViewDidLoad() {
        rx.viewDidLoadInvoked
            .subscribe(onNext: { [weak self] _ in
                self?.performBinding()
            })
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: UIViewController {
    var viewDidLoad: Observable<Void> {
        return sentMessage(#selector(base.viewDidLoad))
            .map { _ in () }
            .share(replay: 1)
    }

    var viewDidLoadInvoked: Observable<Void> {
        return methodInvoked(#selector(base.viewDidLoad))
            .map { _ in () }
            .share(replay: 1)
    }
}

