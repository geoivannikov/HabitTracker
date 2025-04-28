//
//  HabitCategoryPredictor.swift
//  HabitTracker
//
//  Created by Ivannikov-EXTERNAL Georgiy on 26.04.2025.
//

import CoreML

class HabitCategoryPredictor {
    private let model: HabitClassifier

    init() {
        do {
            self.model = try HabitClassifier(configuration: .init())
        } catch {
            fatalError("Не удалось загрузить модель: \(error)")
        }
    }

    func predictCategory(for habit: String) -> String? {
        do {
            let prediction = try model.prediction(text: habit)
            return prediction.label
        } catch {
            return nil
        }
    }
}
