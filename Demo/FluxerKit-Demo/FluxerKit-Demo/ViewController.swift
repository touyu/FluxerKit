//
//  ViewController.swift
//  FluxerKit-Demo
//
//  Created by Yuto Akiba on 2019/03/19.
//  Copyright © 2019 Yuto Akiba. All rights reserved.
//

import UIKit
import RxSwift
import FluxerKit

final class ViewController: UIViewController, FluxerStoryboardBindable {
    typealias Fluxer = ViewFluxer

    var disposeBag = DisposeBag()

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    func bind(fluxer: ViewFluxer) {
        minusButton.rx.tap
            .map { Fluxer.Action.decrease }
            .bind(to: fluxer.action)
            .disposed(by: disposeBag)

        plusButton.rx.tap
            .map { Fluxer.Action.increase }
            .bind(to: fluxer.action)
            .disposed(by: disposeBag)

        fluxer.store.value
            .map { $0.description }
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

