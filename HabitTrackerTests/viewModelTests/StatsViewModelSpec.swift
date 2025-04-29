//
//  StatsViewModelSpec.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 29.04.2025.
//

import Quick
import Nimble
import Foundation

@testable import HabitTracker

final class StatsViewModelSpec: QuickSpec {
    override class func spec() {
        describe("StatsViewModel") {
            var mockDatabaseService: MockDatabaseService!
            var viewModel: StatsViewModel!

            beforeEach {
                DIContainer.shared.reset()
                mockDatabaseService = MockDatabaseService()
                DIContainer.shared.register(DatabaseServiceProtocol.self) { mockDatabaseService }
                viewModel = StatsViewModel()
            }

            context("when loading habits successfully") {
                it("populates habits array") {
                    let habit = Habit(name: "Workout", category: .health, scheduledDays: [2], reminderTime: nil)
                    mockDatabaseService.fetchedHabits = [habit]
                    viewModel.loadHabits()
                    expect(viewModel.habits).to(haveCount(1))
                    expect(viewModel.errorMessage).to(beNil())
                }
            }

            context("when loading habits fails") {
                it("sets errorMessage") {
                    mockDatabaseService.shouldThrowOnFetch = true
                    viewModel.loadHabits()
                    expect(viewModel.habits).to(beEmpty())
                    expect(viewModel.errorMessage).toNot(beNil())
                }
            }

            context("totalCompletedCount calculation") {
                it("counts only habits completed today") {
                    let today = Date()
                    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!

                    let habitToday = Habit(name: "Meditate", category: .health, scheduledDays: [2], reminderTime: nil)
                    habitToday.lastCompletionDate = today

                    let habitYesterday = Habit(name: "Read", category: .selfImprovement, scheduledDays: [2], reminderTime: nil)
                    habitYesterday.lastCompletionDate = yesterday

                    viewModel.habits = [habitToday, habitYesterday]
                    expect(viewModel.totalCompletedCount).to(equal(1))
                }
            }

            context("currentStreak calculation") {
                it("calculates correct streak") {
                    let today = Date()
                    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
                    let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!

                    let habitToday = Habit(name: "Run", category: .health, scheduledDays: [2], reminderTime: nil)
                    habitToday.lastCompletionDate = today

                    let habitYesterday = Habit(name: "Swim", category: .health, scheduledDays: [2], reminderTime: nil)
                    habitYesterday.lastCompletionDate = yesterday

                    let habitTwoDaysAgo = Habit(name: "Yoga", category: .health, scheduledDays: [2], reminderTime: nil)
                    habitTwoDaysAgo.lastCompletionDate = twoDaysAgo

                    viewModel.habits = [habitToday, habitYesterday, habitTwoDaysAgo]
                    expect(viewModel.currentStreak).to(equal(3))
                }

                it("breaks streak if missing day") {
                    let today = Date()
                    let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!

                    let habitToday = Habit(name: "Gym", category: .health, scheduledDays: [2], reminderTime: nil)
                    habitToday.lastCompletionDate = today

                    let habitTwoDaysAgo = Habit(name: "Read", category: .health, scheduledDays: [2], reminderTime: nil)
                    habitTwoDaysAgo.lastCompletionDate = twoDaysAgo

                    viewModel.habits = [habitToday, habitTwoDaysAgo]
                    expect(viewModel.currentStreak).to(equal(1))
                }
            }

            context("weeklyData calculation") {
                it("returns correct 7-day data") {
                    let today = Date()

                    var completedHabits: [Habit] = []
                    for offset in 0..<7 {
                        let date = Calendar.current.date(byAdding: .day, value: -offset, to: today)!
                        let habit = Habit(name: "Habit \(offset)", category: .health, scheduledDays: [2], reminderTime: nil)
                        habit.lastCompletionDate = date
                        completedHabits.append(habit)
                    }

                    viewModel.habits = completedHabits
                    let data = viewModel.weeklyData
                    expect(data).to(haveCount(7))
                    expect(data.map { $0.1 }).to(allPass { $0 == 1 })
                }
            }
        }
    }
}
