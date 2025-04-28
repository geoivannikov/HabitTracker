//
//  NotificationService.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 28.04.2025.
//

import UserNotifications

final class NotificationService {
    static let shared = NotificationService()
    
    private init() {}
    
    func requestPermission() async throws {
        try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
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

            UNUserNotificationCenter.current().add(request)
        }
    }
}
