//
//  AddHabitViewModel.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 23.04.2025.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
final class AddHabitViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var selectedDays: Set<Int> = []
    @Published var hasReminder: Bool = false
    @Published var reminderTime: Date = Date()
    @Published var errorMessage: String?

    private let service: DatabaseService

    init(context: ModelContext) {
        self.service = DatabaseService(context: context)
    }

    var isValid: Bool {
        !name.isEmpty && !selectedDays.isEmpty
    }

    func saveHabit() -> Bool {
        guard isValid else {
            errorMessage = "Please fill in all required fields."
            return false
        }

        let habit = Habit(
            name: name,
            scheduledDays: Array(selectedDays),
            reminderTime: hasReminder ? reminderTime : nil,
            colorHex: "#34C759",
            iconName: "checkmark"
        )

        do {
            try service.create(habit)
            return true
        } catch {
            errorMessage = "Failed to save habit: \(error.localizedDescription)"
            return false
        }
    }
}
