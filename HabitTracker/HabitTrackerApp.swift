//
//  HabitTrackerApp.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 19.04.2025.
//

import SwiftUI
import SwiftData

@main
struct HabitTrackerApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Habit.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
    
    init() {
        setupDependencies()
        requestPermissions()
    }
    
    private func requestPermissions() {
        Task {
            let notificationService: NotificationServiceProtocol = DIContainer.shared.resolve()
            try await notificationService.requestPermission()
        }
    }
    
    private func setupDependencies() {
        DIContainer.shared.register(DatabaseServiceProtocol.self) {
            DatabaseService(context: sharedModelContainer.mainContext)
        }
        DIContainer.shared.register(NotificationServiceProtocol.self) {
            NotificationService.shared
        }
    }
}
