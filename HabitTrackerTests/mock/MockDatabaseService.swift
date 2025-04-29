//
//  MockDatabaseService.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 29.04.2025.
//

import Foundation

@testable import HabitTracker

final class MockDatabaseService: DatabaseServiceProtocol {
    var fetchedHabits: [Habit] = []
    var shouldThrowOnFetch = false
    var shouldThrowOnUpdate = false
    var shouldThrowOnCreate = false
    var shouldThrowOnDeleteAll = false
    var createdHabit: Habit?
    var didDeleteAllHabits = false

    func create<T>(_ model: T) throws where T : DatabaseModel {
        if shouldThrowOnCreate { throw NSError(domain: "", code: 0) }
        createdHabit = model as? Habit
    }

    func fetch<T>(of type: T.Type, sortDescriptors: [SortDescriptor<T>]) throws -> [T] where T : DatabaseModel {
        if shouldThrowOnFetch { throw NSError(domain: "", code: 0) }
        return fetchedHabits as! [T]
    }

    func update(_ block: () throws -> Void) throws {
        if shouldThrowOnUpdate { throw NSError(domain: "", code: 0) }
        try block()
    }

    func delete<T>(_ model: T) throws where T : DatabaseModel {}

    func deleteAll<T>(of type: T.Type) throws where T : DatabaseModel {
        if shouldThrowOnDeleteAll { throw NSError(domain: "", code: 0) }
        didDeleteAllHabits = true
    }
}

