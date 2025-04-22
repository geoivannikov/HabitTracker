//
//  HabitStore.swift.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 22.04.2025.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
class TodayViewModel: ObservableObject {
    private var service: HabitDataService?
    @Published var todayHabits: [Habit] = []

    func injectContext(_ context: ModelContext) {
        if service == nil {
            service = HabitDataService(context: context)
        }
    }

    func loadTodayHabits() {
        todayHabits = [
            Habit(
                        name: "Read 10 pages",
                        scheduledDays: [2, 3, 4, 5, 6], // Mon–Fri
                        reminderTime: nil,
                        colorHex: "#FF6B6B",
                        iconName: "book.fill",
                        lastCompletionDate: nil
                    ),
                    Habit(
                        name: "Drink water",
                        scheduledDays: [1, 2, 3, 4, 5, 6, 7],
                        reminderTime: nil,
                        colorHex: "#34C759",
                        iconName: "drop.fill",
                        lastCompletionDate: Date() // pretend it was completed today
                    ),
                    Habit(
                        name: "Exercise",
                        scheduledDays: [2, 4, 6],
                        reminderTime: nil,
                        colorHex: "#5AC8FA",
                        iconName: "figure.walk",
                        lastCompletionDate: nil
                    )
        ]
//        todayHabits = service?.fetchTodayHabits() ?? []
    }

    func toggleHabit(_ habit: Habit) {
//        if habit.isCompletedToday() {
//            habit.lastCompletionDate = nil
//        } else {
//            service?.markAsCompletedToday(habit)
//        }
//        loadTodayHabits()
    }
}

