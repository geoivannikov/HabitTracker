//
//  SettingsViewModel.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 22.04.2025.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var selectedTheme: ThemeMode = .system {
        didSet {
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: "themeMode")
            applyTheme()
        }
    }

    private var modelContext: ModelContext?

    init() {
        if let raw = UserDefaults.standard.string(forKey: "themeMode"),
           let mode = ThemeMode(rawValue: raw) {
            selectedTheme = mode
        } else {
            selectedTheme = .system
        }
    }

    func injectContext(_ context: ModelContext) {
        modelContext = context
    }

    func applyTheme() {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first?.overrideUserInterfaceStyle = selectedTheme.uiStyle
    }

    func resetAllHabits() {
        guard let context = modelContext else { return }
        let descriptor = FetchDescriptor<Habit>()
        let habits = (try? context.fetch(descriptor)) ?? []
        habits.forEach { context.delete($0) }
        try? context.save()
    }

    @Published var showResetAlert = false
}
