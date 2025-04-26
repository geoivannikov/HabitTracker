//
//  ContentView.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 19.04.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
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

//struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Habit]
//
//    var body: some View {
//        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Habit(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//        .modelContainer(for: Habit.self, inMemory: true)
//}
