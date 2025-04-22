//
//  SettingsView.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 22.04.2025.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]

    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showResetAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .onChange(of: isDarkMode) { _ in
                            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                        }
                }

                Section(header: Text("Data")) {
                    Button("Reset All Habits", role: .destructive) {
                        showResetAlert = true
                    }
                }

                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    Link("GitHub", destination: URL(string: "https://github.com/geoivannikov/HabitTracker")!)
                }
            }
            .navigationTitle("Settings")
            .alert("Delete all habits?", isPresented: $showResetAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    resetAllHabits()
                }
            }
        }
    }

    private func resetAllHabits() {
        for habit in habits {
            modelContext.delete(habit)
        }
        try? modelContext.save()
    }
}
