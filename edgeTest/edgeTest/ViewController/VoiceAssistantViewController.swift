//
//  VoiceAssistantViewController.swift
//  edgeTest
//
//  Created by Tharik anver  on 10/03/26.
//

import UIKit

class VoiceAssistantViewController: UIViewController {

    @IBOutlet weak var micButton: UIButton!
    private let viewModel = VoiceCommandViewModel()
        private var lastDetectedText = ""

        override func viewDidLoad() {
            super.viewDidLoad()

            viewModel.requestPermission { granted in
                print("Speech Permission:", granted)
            }

            viewModel.onTextDetected = { [weak self] text in
                print("User speaking:", text)
                self?.lastDetectedText = text
            }
        }
    
    
// HOLD START
        @IBAction func micTouchDown(_ sender: UIButton) {

            print("Listening started")

            micButton.tintColor = .red
            lastDetectedText = ""

            viewModel.startListening()
            
            UIView.animate(withDuration: 0.2) {
                self.micButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }
            
        }

        // HOLD RELEASE
        @IBAction func micTouchUp(_ sender: UIButton) {

            print("Listening stopped")

            micButton.tintColor = .systemBlue

            viewModel.stopListening()

            processFinalCommand()
            
            UIView.animate(withDuration: 0.2) {
                self.micButton.transform = .identity
            }
            
        }

        private func processFinalCommand() {

            guard !lastDetectedText.isEmpty else { return }

            print("Final sentence:", lastDetectedText)

            viewModel.processCommand(text: lastDetectedText)
        }
}
