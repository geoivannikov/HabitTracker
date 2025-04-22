//
//  AddHabitView.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 22.04.2025.
//

import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name = ""
    @State private var selectedDays: Set<Int> = []
    @State private var reminderTime: Date = Date()
    @State private var hasReminder = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Name")) {
                    TextField("Enter habit name", text: $name)
                }

                Section(header: Text("Repeat On")) {
                    WeekdayPicker(selectedDays: $selectedDays)
                }

                Section(header: Text("Reminder")) {
                    Toggle("Enable Reminder", isOn: $hasReminder)
                    if hasReminder {
                        DatePicker("Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    }
                }
            }
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let habit = Habit(
                            name: name,
                            scheduledDays: Array(selectedDays),
                            reminderTime: hasReminder ? reminderTime : nil,
                            colorHex: "#34C759", // default
                            iconName: "checkmark" // default
                        )
                        modelContext.insert(habit)
                        try? modelContext.save()
                        dismiss()
                    }.disabled(name.isEmpty || selectedDays.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
