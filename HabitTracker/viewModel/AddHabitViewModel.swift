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

    private let databaseService: DatabaseService
    private let notificationService: NotificationService

    init(context: ModelContext, notificationService: NotificationService = NotificationService.shared) {
        self.databaseService = DatabaseService(context: context)
        self.notificationService = notificationService
    }

    var isValid: Bool {
        !name.isEmpty && !selectedDays.isEmpty
    }

    func saveHabit() -> Bool {
        guard isValid else {
            errorMessage = "Please fill in all required fields."
            return false
        }
        
        let predictor = HabitCategoryPredictor()
        let category = HabitCategory(categoryName: predictor.predictCategory(for: name))

        let habit = Habit(name: name,
                          category: category,
                          scheduledDays: Array(selectedDays),
                          reminderTime: hasReminder ? reminderTime : nil)

        do {
            try databaseService.create(habit)
            try notificationService.scheduleHabitReminder(habit: habit)
            return true
        } catch {
            errorMessage = "Failed to save habit: \(error.localizedDescription)"
            return false
        }
    }
}
