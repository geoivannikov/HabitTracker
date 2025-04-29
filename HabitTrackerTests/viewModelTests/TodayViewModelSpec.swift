//
//  TodayViewModelSpec.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 29.04.2025.
//

import Quick
import Nimble
import XCTest

@testable import HabitTracker

final class TodayViewModelSpec: QuickSpec {
    override class func spec() {
        describe("TodayViewModel") {
            var mockDatabaseService: MockDatabaseService!
            var viewModel: TodayViewModel!

            beforeEach {
                DIContainer.shared.reset()
                mockDatabaseService = MockDatabaseService()
                DIContainer.shared.register(DatabaseServiceProtocol.self) { mockDatabaseService }
                viewModel = TodayViewModel()
            }

            context("when loading habits successfully") {
                it("populates todayHabits") {
                    let habit = Habit(name: "Drink Water",
                                      category: .health,
                                      scheduledDays: [2],
                                      reminderTime: nil)
                    mockDatabaseService.fetchedHabits = [habit]
                    viewModel.loadTodayHabits()
                    expect(viewModel.todayHabits).to(haveCount(1))
                    expect(viewModel.todayHabits.first?.name).to(equal("Drink Water"))
                    expect(viewModel.errorMessage).to(beNil())
                }
            }

            context("when loading habits fails") {
                it("sets errorMessage") {
                    mockDatabaseService.shouldThrowOnFetch = true
                    viewModel.loadTodayHabits()
                    expect(viewModel.todayHabits).to(beEmpty())
                    expect(viewModel.errorMessage).toNot(beNil())
                }
            }

            context("when toggling a habit successfully") {
                it("updates lastCompletionDate") {
                    let habit = Habit(name: "Workout",
                                      category: .health,
                                      scheduledDays: [2],
                                      reminderTime: nil)
                    viewModel.todayHabits = [habit]
                    viewModel.toggleHabit(habit)
                    expect(habit.isCompletedToday).to(beTrue())
                    expect(viewModel.errorMessage).to(beNil())
                }
            }

            context("when toggling a habit fails") {
                it("sets errorMessage") {
                    let habit = Habit(name: "Meditate",
                                      category: .health,
                                      scheduledDays: [2],
                                      reminderTime: nil)
                    viewModel.todayHabits = [habit]
                    mockDatabaseService.shouldThrowOnUpdate = true
                    viewModel.toggleHabit(habit)
                    expect(viewModel.errorMessage).toNot(beNil())
                }
            }
        }
    }
}
