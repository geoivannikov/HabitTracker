//
//  NotificationService.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 28.04.2025.
//

import UserNotifications

protocol UNUserNotificationCenterProtocol {
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?)
}

extension UNUserNotificationCenter: UNUserNotificationCenterProtocol {}


protocol NotificationServiceProtocol {
    func requestPermission() async throws
    func scheduleHabitReminder(habit: Habit) throws
}

final class NotificationService: NotificationServiceProtocol {
    static let shared = NotificationService()
    private let center: UNUserNotificationCenterProtocol

    init(center: UNUserNotificationCenterProtocol = UNUserNotificationCenter.current()) {
        self.center = center
    }

    func requestPermission() async throws {
        _ = try await center.requestAuthorization(options: [.alert, .sound, .badge])
    }

    func scheduleHabitReminder(habit: Habit) throws {
        guard let reminderTime = habit.reminderTime else { return }

        habit.scheduledDays.forEach { day in
            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
            dateComponents.weekday = day

            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = "Time to do the habit: \(habit.name)"
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

            let request = UNNotificationRequest(
                identifier: "\(habit.id.uuidString)_\(day)",
                content: content,
                trigger: trigger
            )

            center.add(request, withCompletionHandler: nil)
        }
    }
}
