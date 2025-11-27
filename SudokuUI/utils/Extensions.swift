//
//  Extensions.swift
//  Sudoku
//
//  Created by Jared Cassoutt on 11/8/24.
//
import Foundation
import Combine
import SwiftUI

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

@discardableResult
func assignIfChanged<T: Equatable>(_ current: inout T, _ newValue: T) -> Bool {
    guard current != newValue else { return false }
    current = newValue
    return true
}

@propertyWrapper
struct EquatablePublished<Value: Equatable> {
    private var value: Value
    let publisher = PassthroughSubject<Value,Never>()
    var wrappedValue: Value {
        get { value }
        set {
            guard value != newValue else { return }
            value = newValue
            publisher.send(value)
        }
    }
    init(wrappedValue: Value) {
        self.value = wrappedValue
    }
}

extension EquatablePublished: DynamicProperty {
    var projectedValue: AnyPublisher<Value,Never> {
        publisher.eraseToAnyPublisher()
    }
}
