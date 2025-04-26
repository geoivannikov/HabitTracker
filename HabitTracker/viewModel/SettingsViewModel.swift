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
    @Published var showResetAlert = false
    @Published var selectedTheme: ThemeMode = .system {
        didSet {
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: "themeMode")
            applyTheme()
        }
    }

    private let service: DatabaseService

    init(context: ModelContext) {
        self.service = DatabaseService(context: context)
        if let raw = UserDefaults.standard.string(forKey: "themeMode"),
           let mode = ThemeMode(rawValue: raw) {
            selectedTheme = mode
        } else {
            selectedTheme = .system
        }
    }

    func applyTheme() {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .first?.overrideUserInterfaceStyle = selectedTheme.uiStyle
    }

    func resetAllHabits() {
        try? service.deleteAll(of: Habit.self)
    }
}
