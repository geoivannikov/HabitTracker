//
//  HabitStore.swift.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 22.04.2025.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
final class TodayViewModel: ObservableObject {
    @Published var todayHabits: [Habit] = []
    @Published var errorMessage: String?

    private let service: DatabaseServiceProtocol = DIContainer.shared.resolve()

    func loadTodayHabits() {
        do {
            let allHabits = try service.fetch(of: Habit.self, sortDescriptors: [])
            todayHabits = allHabits.filter { ($0.isScheduledForToday) }
        } catch {
            errorMessage = "Failed to load today's habits: \(error.localizedDescription)"
        }
    }

    func toggleHabit(_ habit: Habit) {
        do {
            try service.update {
                habit.lastCompletionDate = habit.isCompletedToday ? nil : Date()
            }

            if let index = todayHabits.firstIndex(where: { $0.id == habit.id }) {
                todayHabits[index] = habit
            }
        } catch {
            errorMessage = "Failed to update habit: \(error.localizedDescription)"
        }
    }
}
