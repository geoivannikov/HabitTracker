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
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Appearance")) {
                    Picker("Theme", selection: $viewModel.selectedTheme) {
                        ForEach(ThemeMode.allCases) { mode in
                            Text(mode.label).tag(mode)
                        }
                    }
                }

                Section(header: Text("Data")) {
                    Button("Reset All Habits", role: .destructive) {
                        viewModel.showResetAlert = true
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
            .alert("Delete all habits?", isPresented: $viewModel.showResetAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    viewModel.resetAllHabits()
                }
            }
        }
        .onAppear {
            viewModel.injectContext(modelContext)
        }
    }
}
