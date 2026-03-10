//
//  SpeechService.swift
//  edgeTest
//
//  Created by Tharik anver  on 10/03/26.
//

import Speech
import AVFoundation

class SpeechService {

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let audioEngine = AVAudioEngine()

    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    func requestPermission(completion: @escaping (Bool) -> Void) {

        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status == .authorized)
            }
        }
    }

    func startListening(onResult: @escaping (String) -> Void) {

        stopListening()

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true

        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session error:", error)
        }

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        inputNode.removeTap(onBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            (buffer, _) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()

        do {
            try audioEngine.start()
        } catch {
            print("Audio engine error:", error)
        }

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!) { result, error in

            if let result = result {

                let text = result.bestTranscription.formattedString.lowercased()

                DispatchQueue.main.async {
                    onResult(text)
                }
            }

            if error != nil {
                self.stopListening()
            }
        }
    }

    func stopListening() {

        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)

        recognitionRequest?.endAudio()
        recognitionRequest = nil

        recognitionTask?.cancel()
        recognitionTask = nil
    }
}
