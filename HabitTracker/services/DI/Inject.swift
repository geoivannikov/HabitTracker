//
//  Inject.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 29.04.2025.
//

@propertyWrapper
struct Inject<T> {
    let wrappedValue: T

    init(resolver: Resolver = DIContainer.shared) {
        self.wrappedValue = resolver.resolve()
    }
}
