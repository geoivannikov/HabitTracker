//
//  WeekdayPicker.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 22.04.2025.
//

import SwiftUI

struct WeekdayPicker: View {
    @Binding var selectedDays: Set<Int>

    let weekdays = Calendar.current.shortWeekdaySymbols
    var orderedWeekdays: [String] {
        Array(weekdays[1...6]) + [weekdays[0]]
    }

    var body: some View {
        HStack {
            ForEach(0..<7, id: \.self) { index in
                let displayIndex = (index + 1) % 7
                let isSelected = selectedDays.contains(displayIndex)

                Text(orderedWeekdays[index])
                    .frame(width: 40, height: 40)
                    .background(isSelected ? Color.blue : Color.gray)
                    .foregroundColor(isSelected ? .white : .primary)
                    .clipShape(Circle())
                    .contentShape(Circle())
                    .onTapGesture {
                        if isSelected {
                            selectedDays.remove(displayIndex)
                        } else {
                            selectedDays.insert(displayIndex)
                        }
                    }
            }
        }
        .padding()
    }
}
