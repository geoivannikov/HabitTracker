//
//  ContentView.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 19.04.2025.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        TabView {
            TodayView(modelContext: modelContext)
                .tabItem {
                    Label("Today", systemImage: "calendar")
                }
            StatsView(modelContext: modelContext)
                .tabItem {
                    Label("Stats", systemImage: "chart.bar")
                }
            SettingsView(modelContext: modelContext)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
