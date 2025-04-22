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
    @StateObject private var viewModel: TodayViewModel = TodayViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.todayHabits) { habit in
                    HStack {
                        Text(habit.name)
                        Spacer()
                        Button {
                            viewModel.toggleHabit(habit)
                        } label: {
                            Image(systemName: habit.isCompletedToday() ? "checkmark.circle.fill" : "circle")
                        }
                    }
                }
            }
            .navigationTitle("Today")
        }
        .onAppear {
            viewModel.injectContext(modelContext)
            viewModel.loadTodayHabits()
        }
    }
}
