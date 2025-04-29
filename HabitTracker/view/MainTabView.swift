//
//  MainTabView.swift
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
            ForEach(TabItem.allCases, id: \.self) { tab in
                view(for: tab)
                    .tabItem {
                        Label(tab.rawValue, systemImage: tab.systemImageName)
                    }
            }
        }
    }
    
    private func view(for tab: TabItem) -> some View {
        switch tab {
        case .today:
            return AnyView(TodayView())
        case .stats:
            return AnyView(StatsView())
        case .settings:
            return AnyView(SettingsView())
        }
    }
}
