//
//  NotificationServiceSpec.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 29.04.2025.
//

import Quick
import Nimble
import Foundation

@testable import HabitTracker

final class NotificationServiceSpec: QuickSpec {
    override class func spec() {
        describe("NotificationService") {
            var mockCenter: MockUserNotificationCenter!
            var service: NotificationService!

            beforeEach {
                mockCenter = MockUserNotificationCenter()
                service = NotificationService(center: mockCenter)
            }

            context("requestPermission") {
                it("requests notification authorization") {
                    waitUntil { done in
                        Task {
                            try await service.requestPermission()
                            expect(mockCenter.didRequestAuthorization).to(beTrue())
                            done()
                        }
                    }
                }
            }

            context("scheduleHabitReminder") {
                it("does not schedule notifications when reminderTime is nil") {
                    let habit = Habit(id: UUID(),
                                      name: "Test",
                                      category: .health,
                                      scheduledDays: [2, 4, 6],
                                      reminderTime: nil)
                    try service.scheduleHabitReminder(habit: habit)
                    expect(mockCenter.addedRequests).to(beEmpty())
                }

                it("schedules notifications for each scheduled day when reminderTime is set") {
                    let reminderTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
                    let habit = Habit(id: UUID(),
                                      name: "Test Habit",
                                      category: .fitness,
                                      scheduledDays: [2, 4],
                                      reminderTime: reminderTime)

                    try service.scheduleHabitReminder(habit: habit)

                    expect(mockCenter.addedRequests.count).to(equal(2))

                    let identifiers = mockCenter.addedRequests.map { $0.identifier }
                    expect(identifiers).to(contain("\(habit.id.uuidString)_2"))
                    expect(identifiers).to(contain("\(habit.id.uuidString)_4"))

                    let contents = mockCenter.addedRequests.map { $0.content }
                    expect(contents.allSatisfy { $0.title == "Reminder" }).to(beTrue())
                    expect(contents.allSatisfy { $0.body.contains(habit.name) }).to(beTrue())
                }
            }
        }
    }
}
