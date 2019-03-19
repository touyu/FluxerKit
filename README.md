# FluxerKit (Beta)

![Swift 4.2.1](https://img.shields.io/badge/Swift-4.2.1-orange.svg)
<img src="https://img.shields.io/badge/platforms-iOS-lightgrey.svg">
<a href="https://github.com/Carthage/Carthage/"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"></a>
<img src="https://img.shields.io/badge/license-MIT-blue.svg">

Flux framework inspired by [ReactorKit](https://github.com/ReactorKit/ReactorKit)

## Introduction

ReactorKit is a very awesome framework.
It brings order to the code.

However, There are parts of ReactorKit that I don't like.
1. Must use `distinctUntilChanged` when observing changes in state.
2. Can't create an element of state without initial value
3. Unstable `Method Swizzling`
4. No official carthage support

FluxerKit solve these.

## Dependencies
- RxSwift >= 4.0
- RxCocoa >= 4.0

## Requirements
- Swift 4
- iOS 8

## Installation

### Carthage
FluxerKit officially supports Carthage.
 
Add the following line to Cartfile:
```
github "touyu/FluxerKit"
```

## Usage
Basically it is similar to how to use `ReactorKit`.

|   FluxerKit    |    ReactorKit     |  
|:--------------:|:-----------------:|
|   Fluxer      |    Reactor         |
|   Dispatcher   |    Mutation       |
|   Store        |    State          |
|   dispatch()     |    mutate()     |
|   updateStore()  |    reduce()     |
|   FluxerBindable |   View          |
|   FluxerStoryboardBindable |   StorybardView   |

### ViewController

```swift
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
```

### ViewFluxer

```swift
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
        var value = BehaviorSubject<Int>(value: 0)
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
```
