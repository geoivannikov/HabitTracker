//
//  StatsViewModel.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 22.04.2025.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class StatsViewModel: ObservableObject {
    @Published var habits: [Habit] = []

    private var modelContext: ModelContext?

    func injectContext(_ context: ModelContext) {
        self.modelContext = context
        loadHabits()
    }

    func loadHabits() {
        guard let context = modelContext else { return }
        let descriptor = FetchDescriptor<Habit>()
        habits = (try? context.fetch(descriptor)) ?? []
    }

    var totalCompletedCount: Int {
        habits.reduce(0) { count, habit in
            if let date = habit.lastCompletionDate {
                return count + (Calendar.current.isDateInToday(date) ? 1 : 0)
            }
            return count
        }
    }

    var currentStreak: Int {
        let calendar = Calendar.current
        var streak = 0
        for offset in (0..<30).reversed() {
            let date = calendar.date(byAdding: .day, value: -offset, to: Date())!
            let completed = habits.contains {
                guard let d = $0.lastCompletionDate else { return false }
                return calendar.isDate(d, inSameDayAs: date)
            }

            if completed {
                streak += 1
            } else if streak > 0 {
                break
            }
        }
        return streak
    }

    var weeklyData: [(String, Int)] {
        let calendar = Calendar.current
        let days = (0..<7).map { offset -> (String, Int) in
            let date = calendar.date(byAdding: .day, value: -offset, to: Date())!
            let count = habits.filter {
                guard let d = $0.lastCompletionDate else { return false }
                return calendar.isDate(d, inSameDayAs: date)
            }.count

            let daySymbol = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
            return (daySymbol, count)
        }
        return days.reversed()
    }
}
