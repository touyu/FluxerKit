//
//  FluxerBindable.swift
//  FluxerKit
//
//  Created by Yuto Akiba on 2019/03/19.
//  Copyright © 2019 Yuto Akiba. All rights reserved.
//

import RxSwift

var fluxerKey = "fluxer"
var isReactorBindedKey = "isReactorBindedKey"

public protocol FluxerBindable: class, AssociatedObjectStore {
    associatedtype Fluxer: FluxerKit.Fluxer
    var disposeBag: DisposeBag { get set }
    var fluxer: Fluxer? { get }
    func bind(fluxer: Fluxer)
}

extension FluxerBindable {
    public var fluxer: Fluxer? {
        get { return self.associatedObject(forKey: &fluxerKey) }
        set {
            self.setAssociatedObject(newValue, forKey: &fluxerKey)
            self.disposeBag = DisposeBag()
            if let fluxer = newValue {
                self.bind(fluxer: fluxer)
            }
        }
    }
}
