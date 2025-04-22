//
//  HabitDataService.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 22.04.2025.
//

import Foundation
import SwiftData

class HabitDataService {
    let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchAll() -> [Habit] {
        let descriptor = FetchDescriptor<Habit>()
        return (try? context.fetch(descriptor)) ?? []
    }

    func fetchTodayHabits() -> [Habit] {
        fetchAll().filter { $0.isScheduledForToday() }
    }

    func save(_ habit: Habit) {
//        if context.insertedObjects.contains(habit) == false {
//            context.insert(habit)
//        }
        try? context.save()
    }

    func delete(_ habit: Habit) {
        context.delete(habit)
        try? context.save()
    }

    func markAsCompletedToday(_ habit: Habit) {
        habit.lastCompletionDate = Date()
        try? context.save()
    }
}
