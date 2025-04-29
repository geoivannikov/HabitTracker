//
//  SettingsViewModelSpec.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 29.04.2025.
//

import Quick
import Nimble
import Foundation

@testable import HabitTracker

final class SettingsViewModelSpec: QuickSpec {
    override class func spec() {
        describe("SettingsViewModel") {
            var mockDatabaseService: MockDatabaseService!
            var viewModel: SettingsViewModel!

            beforeEach {
                DIContainer.shared.reset()
                mockDatabaseService = MockDatabaseService()
                DIContainer.shared.register(DatabaseServiceProtocol.self) { mockDatabaseService }
                viewModel = SettingsViewModel()
            }

            context("on initialization") {
                it("loads theme from UserDefaults if available") {
                    UserDefaults.standard.set(ThemeMode.dark.rawValue, forKey: "themeMode")
                    let vm = SettingsViewModel()
                    expect(vm.selectedTheme).to(equal(.dark))
                }

                it("defaults to system theme if no value in UserDefaults") {
                    UserDefaults.standard.removeObject(forKey: "themeMode")
                    let vm = SettingsViewModel()
                    expect(vm.selectedTheme).to(equal(.system))
                }
            }

            context("when resetting all habits successfully") {
                it("completes without error") {
                    viewModel.resetAllHabits()
                    expect(viewModel.errorMessage).to(beNil())
                    expect(mockDatabaseService.didDeleteAllHabits).to(beTrue())
                }
            }

            context("when resetting habits fails") {
                it("sets errorMessage") {
                    mockDatabaseService.shouldThrowOnDeleteAll = true
                    viewModel.resetAllHabits()
                    expect(viewModel.errorMessage).toNot(beNil())
                }
            }
        }
    }
}
