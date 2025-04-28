//
//  TodayView.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 22.04.2025.
//

import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: TodayViewModel
    @State private var isPresentingAddHabit = false

    var body: some View {
        NavigationStack {
            List {
                if viewModel.todayHabits.isEmpty {
                    ContentUnavailableView("No habits for today", systemImage: "moon.zzz")
                } else {
                    ForEach(viewModel.todayHabits) { habit in
                        HStack {
                            Circle()
                                .fill(habit.category.color)
                                .frame(width: 20, height: 20)
                            Text(habit.name)
                                .font(.body)
                            Spacer()
                            Button {
                                viewModel.toggleHabit(habit)
                            } label: {
                                Image(systemName: habit.isCompletedToday ? "checkmark.circle.fill" : "circle")
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresentingAddHabit = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingAddHabit, onDismiss: viewModel.loadTodayHabits) {
                AddHabitView(modelContext: modelContext)
            }
            .onAppear(perform: viewModel.loadTodayHabits)
        }
        .errorAlert(errorMessage: $viewModel.errorMessage)
    }

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: TodayViewModel(context: modelContext))
    }
}

