//
//  UIViewController+Extension.swift
//  FluxerKit
//
//  Created by Yuto Akiba on 2019/03/19.
//  Copyright © 2019 Yuto Akiba. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
