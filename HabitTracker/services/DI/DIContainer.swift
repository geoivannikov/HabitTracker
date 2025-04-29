//
//  DIContainer.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 28.04.2025.
//

import SwiftData

protocol Resolver {
    func resolve<T>() -> T
}

final class DIContainer: Resolver {
    static let shared = DIContainer()

    private var factories: [ObjectIdentifier: () -> Any] = [:]

    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        factories[ObjectIdentifier(type)] = factory
    }

    func resolve<T>() -> T {
        guard let factory = factories[ObjectIdentifier(T.self)],
              let instance = factory() as? T else {
            fatalError("No registration for type \(T.self)")
        }
        return instance
    }

    func reset() {
        factories.removeAll()
    }
}
