//
//  HabitModelSpec.swift
//  HabitTrackerTests
//
//  Created by Ivannikov-EXTERNAL Georgiy on 29.04.2025.
//

import Quick
import Nimble
import Foundation

@testable import HabitTracker

final class HabitModelSpec: QuickSpec {
    override class func spec() {
        describe("Habit model") {
            var habit: Habit!

            context("isCompletedToday") {
                it("returns true if lastCompletionDate is today") {
                    let today = Date()
                    habit = Habit(name: "Test", category: .health, scheduledDays: [], reminderTime: nil, lastCompletionDate: today)
                    expect(habit.isCompletedToday).to(beTrue())
                }

                it("returns false if lastCompletionDate is nil") {
                    habit = Habit(name: "Test", category: .health, scheduledDays: [], reminderTime: nil, lastCompletionDate: nil)
                    expect(habit.isCompletedToday).to(beFalse())
                }

                it("returns false if lastCompletionDate is not today") {
                    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
                    habit = Habit(name: "Test", category: .health, scheduledDays: [], reminderTime: nil, lastCompletionDate: yesterday)
                    expect(habit.isCompletedToday).to(beFalse())
                }
            }

            context("isScheduledForToday") {
                it("returns true if today’s weekday is in scheduledDays") {
                    let todayWeekday = Calendar.current.component(.weekday, from: Date())
                    let adjusted = todayWeekday == 1 ? 7 : todayWeekday - 1
                    habit = Habit(name: "Test", category: .health, scheduledDays: [adjusted], reminderTime: nil)
                    expect(habit.isScheduledForToday).to(beTrue())
                }

                it("returns false if today’s weekday is not in scheduledDays") {
                    let todayWeekday = Calendar.current.component(.weekday, from: Date())
                    let adjusted = todayWeekday == 1 ? 7 : todayWeekday - 1
                    let nonToday = adjusted == 1 ? 2 : adjusted - 1
                    habit = Habit(name: "Test", category: .health, scheduledDays: [nonToday], reminderTime: nil)
                    expect(habit.isScheduledForToday).to(beFalse())
                }
            }
        }
    }
}
