# FluxerKit

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
Add the following line to Cartfile:
```
github "touyu/FluxerKit"
```
