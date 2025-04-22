//
//  Item.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 19.04.2025.
//

import Foundation
import SwiftData

import Foundation
import SwiftData

@Model
class Habit {
    @Attribute(.unique) var id: UUID
    var name: String
    var scheduledDays: [Int]
    var reminderTime: Date?
    var colorHex: String
    var iconName: String
    var lastCompletionDate: Date?

    init(
        id: UUID = UUID(),
        name: String,
        scheduledDays: [Int],
        reminderTime: Date? = nil,
        colorHex: String = "#34C759",
        iconName: String = "checkmark",
        lastCompletionDate: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.scheduledDays = scheduledDays
        self.reminderTime = reminderTime
        self.colorHex = colorHex
        self.iconName = iconName
        self.lastCompletionDate = lastCompletionDate
    }

    func isCompletedToday() -> Bool {
        guard let date = lastCompletionDate else { return false }
        return Calendar.current.isDateInToday(date)
    }

    func isScheduledForToday() -> Bool {
        let weekday = Calendar.current.component(.weekday, from: Date())
        return scheduledDays.contains(weekday)
    }
}
