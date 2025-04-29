//
//  AddHabitViewModelSpec.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 29.04.2025.
//

import Quick
import Nimble

@testable import HabitTracker

final class AddHabitViewModelSpec: QuickSpec {
    override class func spec() {
        describe("AddHabitViewModel") {
            var mockDatabaseService: MockDatabaseService!
            var mockNotificationService: MockNotificationService!
            var viewModel: AddHabitViewModel!

            beforeEach {
                DIContainer.shared.reset()
                mockDatabaseService = MockDatabaseService()
                mockNotificationService = MockNotificationService()
                DIContainer.shared.register(DatabaseServiceProtocol.self) { mockDatabaseService }
                DIContainer.shared.register(NotificationServiceProtocol.self) { mockNotificationService }
                viewModel = AddHabitViewModel()
            }

            context("when fields are valid") {
                it("saves habit successfully") {
                    viewModel.name = "Run"
                    viewModel.selectedDays = [2, 4]

                    let result = viewModel.saveHabit()

                    expect(result).to(beTrue())
                    expect(mockDatabaseService.createdHabit?.name).to(equal("Run"))
                    expect(mockNotificationService.didScheduleReminder).to(beTrue())
                    expect(viewModel.errorMessage).to(beNil())
                }
            }

            context("when required fields are missing") {
                it("fails to save and sets errorMessage") {
                    viewModel.name = ""
                    viewModel.selectedDays = []

                    let result = viewModel.saveHabit()

                    expect(result).to(beFalse())
                    expect(viewModel.errorMessage).to(equal("Please fill in all required fields."))
                }
            }

            context("when database service throws") {
                it("fails and sets errorMessage") {
                    viewModel.name = "Read"
                    viewModel.selectedDays = [3]
                    mockDatabaseService.shouldThrowOnCreate = true

                    let result = viewModel.saveHabit()

                    expect(result).to(beFalse())
                    expect(viewModel.errorMessage).to(contain("Failed to save habit"))
                }
            }

            context("when notification service throws") {
                it("fails and sets errorMessage") {
                    viewModel.name = "Yoga"
                    viewModel.selectedDays = [5]
                    mockNotificationService.shouldThrowOnSchedule = true

                    let result = viewModel.saveHabit()

                    expect(result).to(beFalse())
                    expect(viewModel.errorMessage).to(contain("Failed to save habit"))
                }
            }
        }
    }
}
