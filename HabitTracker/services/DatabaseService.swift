//
//  DatabaseService.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 22.04.2025.
//

import Foundation
import SwiftData

final class DatabaseService {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Create

    func create<T: DatabaseModel>(_ model: T) throws {
        context.insert(model)
        try context.save()
    }

    // MARK: - Read

    func fetchAll<T: DatabaseModel>(of type: T.Type, sortDescriptors: [SortDescriptor<T>] = []) throws -> [T] {
        let descriptor = FetchDescriptor<T>(sortBy: sortDescriptors)
        return try context.fetch(descriptor)
    }

    func fetch<T: DatabaseModel>(of type: T.Type) throws -> [T] {
        try context.fetch(FetchDescriptor<T>())
    }

    // MARK: - Update

    func update(_ block: () throws -> Void) throws {
        try block()
        try context.save()
    }

    // MARK: - Delete

    func delete<T: DatabaseModel>(_ model: T) throws {
        context.delete(model)
        try context.save()
    }

    func deleteAll<T: DatabaseModel>(of type: T.Type) throws {
        let all = try fetchAll(of: type)
        for item in all {
            context.delete(item)
        }
        try context.save()
    }
}
