//
//  Item.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 19.04.2025.
//

import Foundation
import SwiftData

@Model
final class Habit: DatabaseModel {
    @Attribute(.unique) var id: UUID
    var name: String
    var category: HabitCategory
    var scheduledDays: [Int]
    var reminderTime: Date?
    var lastCompletionDate: Date?

    init(id: UUID = UUID(),
         name: String,
         category: HabitCategory,
         scheduledDays: [Int],
         reminderTime: Date?,
         lastCompletionDate: Date? = nil) {
        self.id = id
        self.name = name
        self.category = category
        self.scheduledDays = scheduledDays
        self.reminderTime = reminderTime
        self.lastCompletionDate = lastCompletionDate
    }
}

// MARK: - Computed Properties

extension Habit {
    var isCompletedToday: Bool {
        guard let date = lastCompletionDate else { return false }
        return Calendar.current.isDateInToday(date)
    }

    var isScheduledForToday: Bool {
        let todayWeekday = Calendar.current.component(.weekday, from: Date())
        let adjustedWeekday = todayWeekday == 1 ? 7 : todayWeekday - 1
        return scheduledDays.contains(adjustedWeekday)
    }
}
