//
//  StatsView.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 22.04.2025.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Statistics")
                    .font(.largeTitle)
                    .bold()
                VStack(alignment: .leading, spacing: 10) {
                    Text("✅ Total Completed: \(viewModel.totalCompletedCount)")
                        .font(.headline)
                    Text("🔥 Current Streak: \(viewModel.currentStreak) days")
                        .font(.headline)
                }
                .cardStyle()
                Divider()
                Text("This Week")
                    .font(.headline)
                VStack(alignment: .leading) {
                    ForEach(viewModel.weeklyData, id: \.0) { (day, count) in
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
                Spacer()
            }
            .padding()
            .onAppear {
                viewModel.loadHabits()
            }
        }
        .errorAlert(errorMessage: $viewModel.errorMessage)
    }
}
