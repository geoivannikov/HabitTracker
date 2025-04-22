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
    @State private var isPresentingAddHabit = false

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
                        .buttonStyle(.plain)
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
            .sheet(isPresented: $isPresentingAddHabit, onDismiss: {
                viewModel.loadTodayHabits()
            }) {
                AddHabitView()
            }
        }
        .onAppear {
            viewModel.injectContext(modelContext)
            viewModel.loadTodayHabits()
        }
    }
}

