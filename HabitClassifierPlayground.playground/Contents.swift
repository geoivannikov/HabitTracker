import CreateML
import Foundation

let fileURL = URL(fileURLWithPath: "/habits.csv")
let data = try MLDataTable(contentsOf: fileURL)

let model = try MLTextClassifier(trainingData: data, textColumn: "habit", labelColumn: "category")

let saveURL = URL(fileURLWithPath: "/HabitTracker/HabitTracker/ml/HabitClassifier.mlmodel")
try model.write(to: saveURL)
