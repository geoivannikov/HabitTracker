//
//  StatsView.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 22.04.2025.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    @Query private var habits: [Habit]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Statistics")
                    .font(.largeTitle)
                    .bold()

                VStack(alignment: .leading, spacing: 10) {
                    Text("✅ Total Completed: \(totalCompletedCount())")
                    Text("🔥 Current Streak: \(calculateStreak()) days")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))

                Divider()

                Text("This Week")
                    .font(.headline)

                weeklyChart()
                
                Spacer()
            }
            .padding()
        }
    }

    // MARK: - Logic

    private func totalCompletedCount() -> Int {
        habits.reduce(0) { count, habit in
            if let date = habit.lastCompletionDate {
                return count + (Calendar.current.isDateInToday(date) ? 1 : 0)
            }
            return count
        }
    }

    private func calculateStreak() -> Int {
        let calendar = Calendar.current
        var streak = 0
        for offset in (0..<30).reversed() {
            let date = calendar.date(byAdding: .day, value: -offset, to: Date())!
            let habitsCompleted = habits.contains { habit in
                guard let completionDate = habit.lastCompletionDate else { return false }
                return calendar.isDate(completionDate, inSameDayAs: date)
            }

            if habitsCompleted {
                streak += 1
            } else if streak > 0 {
                break
            }
        }
        return streak
    }

    private func weeklyChart() -> some View {
        let calendar = Calendar.current
        let days = (0..<7).map { offset -> (String, Int) in
            let date = calendar.date(byAdding: .day, value: -offset, to: Date())!
            let count = habits.filter {
                guard let d = $0.lastCompletionDate else { return false }
                return calendar.isDate(d, inSameDayAs: date)
            }.count

            let daySymbol = calendar.shortWeekdaySymbols[calendar.component(.weekday, from: date) - 1]
            return (daySymbol, count)
        }.reversed()

        return VStack(alignment: .leading) {
            ForEach(days, id: \.0) { (day, count) in
                HStack {
                    Text(day)
                        .frame(width: 40, alignment: .leading)
                    Rectangle()
                        .fill(.blue)
                        .frame(width: CGFloat(count * 20), height: 10)
                    Text("\(count)")
                }
            }
        }
    }
}
