//
//  StatsView.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 22.04.2025.
//

import SwiftUI
import SwiftData

struct StatsView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = StatsViewModel()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Statistics")
                    .font(.largeTitle)
                    .bold()

                VStack(alignment: .leading, spacing: 10) {
                    Text("✅ Total Completed: \(viewModel.totalCompletedCount)")
                    Text("🔥 Current Streak: \(viewModel.currentStreak) days")
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))

                Divider()

                Text("This Week")
                    .font(.headline)

                weeklyChartView()

                Spacer()
            }
            .padding()
            .onAppear {
                viewModel.injectContext(modelContext)
            }
        }
    }

    @ViewBuilder
    private func weeklyChartView() -> some View {
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
    }
}
