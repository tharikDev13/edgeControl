//
//  IntentClassifierService.swift
//  edgeTest
//
//  Created by Tharik anver  on 10/03/26.
//
import CoreML

class IntentClassifierService {

    private let model: IntentClassifier

    init() {
        model = try! IntentClassifier(configuration: MLModelConfiguration())
    }

    func predictIntent(from text: String) -> String? {

        do {
            let prediction = try model.prediction(text: text)
            return prediction.label
        } catch {
            print(error)
            return nil
        }
    }
}
