//
//  WeekdayPicker.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 22.04.2025.
//

import SwiftUI

struct WeekdayPicker: View {
    @Binding var selectedDays: Set<Int>
    let days = Calendar.current.shortWeekdaySymbols // ["Sun", "Mon", ...]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(1...7, id: \.self) { i in
                let label = days[i % 7] // Sunday = 1 in Calendar

                Button(action: {
                    if selectedDays.contains(i) {
                        selectedDays.remove(i)
                    } else {
                        selectedDays.insert(i)
                    }
                }) {
                    Text(label)
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(selectedDays.contains(i) ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .padding(.horizontal, 2)
            }
        }
    }
}
