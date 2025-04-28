//
//  View+errorAlert.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 28.04.2025.
//

import SwiftUI

extension View {
    func errorAlert(errorMessage: Binding<String?>) -> some View {
        self.modifier(ErrorAlertModifier(errorMessage: errorMessage))
    }
}

extension View {
    func cardStyle() -> some View {
        self.modifier(CardModifier())
    }
}
