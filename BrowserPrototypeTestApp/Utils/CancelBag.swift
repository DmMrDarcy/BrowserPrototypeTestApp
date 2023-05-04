//
//  CancelBag.swift
//  BrowserPrototypeTestApp
//
//  Created by Dmitriy Lukyanov on 04.05.2023.
//

import Combine

open class CancelBag {
    fileprivate(set) var subscriptions = Set<AnyCancellable>()

    public init(){}

    public func cancel() {
        subscriptions.removeAll()
    }
}

extension AnyCancellable {
    public func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
