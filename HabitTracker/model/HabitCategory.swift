//
//  HabitCategory.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 26.04.2025.
//

import SwiftUI

enum HabitCategory: String, Codable, CaseIterable {
    case fitness = "Fitness"
    case health = "Health"
    case selfImprovement = "Self-Improvement"
    case productivity = "Productivity"
    case learning = "Learning"
    case wellness = "Wellness"
    case unknown = "Unknown"
}

extension HabitCategory {
    init(categoryName: String?) {
        self = .init(rawValue: categoryName ?? "") ?? .unknown
    }
}

extension HabitCategory {
    var color: Color {
        switch self {
        case .fitness: return .red
        case .health: return .green
        case .selfImprovement: return .blue
        case .productivity: return .orange
        case .learning: return .purple
        case .wellness: return .pink
        case .unknown: return .gray
        }
    }
}
