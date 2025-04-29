//
//  DatabaseServiceSpec.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 29.04.2025.
//

import Quick
import Nimble
import SwiftData

@testable import HabitTracker

final class DatabaseServiceSpec: QuickSpec {
    override class func spec() {
        describe("DatabaseService") {
            var container: ModelContainer!
            var context: ModelContext!
            var databaseService: DatabaseService!

            beforeEach {
                container = try? ModelContainer(for: Habit.self,
                                                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
                )
                context = container!.mainContext
                databaseService = DatabaseService(context: context)
            }

            it("creates and fetches a habit") {
                let habit = Habit(name: "Test", category: .health, scheduledDays: [1,2], reminderTime: nil)

                try? databaseService.create(habit)
                let fetched: [Habit] = try! databaseService.fetch(of: Habit.self)

                expect(fetched).to(haveCount(1))
                expect(fetched.first?.name).to(equal("Test"))
            }

            it("updates a habit") {
                let habit = Habit(name: "Test", category: .health, scheduledDays: [1], reminderTime: nil)
                try? databaseService.create(habit)

                try? databaseService.update {
                    habit.name = "Updated"
                }

                let fetched: [Habit] = try! databaseService.fetch(of: Habit.self)
                expect(fetched.first?.name).to(equal("Updated"))
            }

            it("deletes a habit") {
                let habit = Habit(name: "Test", category: .health, scheduledDays: [1], reminderTime: nil)
                try? databaseService.create(habit)

                try? databaseService.delete(habit)
                let fetched: [Habit] = try! databaseService.fetch(of: Habit.self)

                expect(fetched).to(beEmpty())
            }

            it("deletes all habits") {
                let habit1 = Habit(name: "H1", category: .health, scheduledDays: [1], reminderTime: nil)
                let habit2 = Habit(name: "H2", category: .health, scheduledDays: [1], reminderTime: nil)
                try? databaseService.create(habit1)
                try? databaseService.create(habit2)

                try? databaseService.deleteAll(of: Habit.self)
                let fetched: [Habit] = try! databaseService.fetch(of: Habit.self)

                expect(fetched).to(beEmpty())
            }
        }
    }
}
