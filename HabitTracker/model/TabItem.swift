//
//  TabItem.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 28.04.2025.
//

enum TabItem: String, CaseIterable {
    case today = "Today"
    case stats = "Stats"
    case settings = "Settings"
}

extension TabItem {
    var systemImageName: String {
        switch self {
        case .today: return "calendar"
        case .stats: return "chart.bar"
        case .settings: return "gear"
        }
    }
}
