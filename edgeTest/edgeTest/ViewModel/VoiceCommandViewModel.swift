//
//  Untitled.swift
//  edgeTest
//
//  Created by Tharik anver  on 10/03/26.
//

import UIKit
import AVFoundation

class VoiceCommandViewModel {

    private let speechService = SpeechService()
    private let intentService = IntentClassifierService()

    var onTextDetected: ((String) -> Void)?

    func startListening() {

        speechService.startListening { [weak self] text in
            self?.onTextDetected?(text)
        }
    }

    func stopListening() {
        speechService.stopListening()
    }

    func requestPermission(completion: @escaping (Bool)->Void) {
        speechService.requestPermission(completion: completion)
    }
    
    func processCommand(text: String) {

        guard let intent = intentService.predictIntent(from: text) else { return }

        print("Intent:", intent)

        CommandExecutor.execute(intent: intent)
    }
    
}
