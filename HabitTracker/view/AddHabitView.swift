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

    @StateObject private var viewModel: AddHabitViewModel
    @State private var isShowingError = false

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: AddHabitViewModel(context: modelContext))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Name")) {
                    TextField("Enter habit name", text: $viewModel.name)
                }

                Section(header: Text("Repeat On")) {
                    WeekdayPicker(selectedDays: $viewModel.selectedDays)
                }

                Section(header: Text("Reminder")) {
                    Toggle("Enable Reminder", isOn: $viewModel.hasReminder)
                    if viewModel.hasReminder {
                        DatePicker("Time", selection: $viewModel.reminderTime, displayedComponents: .hourAndMinute)
                    }
                }
                
                Section(header: Text("Categories list (AI-Generated)")) {
                    ForEach(HabitCategory.allCases, id: \.self) { category in
                        HStack {
                            Text(category.rawValue)
                                .font(.headline)
                            Spacer()
                            Circle()
                                .fill(category.color)
                                .frame(width: 20, height: 20)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if viewModel.saveHabit() {
                            dismiss()
                        }
                    }
                    .disabled(!viewModel.isValid)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $isShowingError) {
                Button("OK", role: .cancel) {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred.")
            }
            .onReceive(viewModel.$errorMessage) { msg in
                isShowingError = msg != nil
            }
        }
    }
}
