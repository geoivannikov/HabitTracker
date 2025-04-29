//
//  MockNotificationService.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 29.04.2025.
//

import Foundation

@testable import HabitTracker

final class MockNotificationService: NotificationServiceProtocol {
    var didScheduleReminder = false
    var shouldThrowOnSchedule = false

    func requestPermission() async throws { }

    func scheduleHabitReminder(habit: Habit) throws {
        if shouldThrowOnSchedule { throw NSError(domain: "", code: 0) }
        didScheduleReminder = true
    }
}
