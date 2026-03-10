//
//  CommandExecutor.swift
//  edgeTest
//
//  Created by Tharik anver  on 10/03/26.
//

import UIKit

class CommandExecutor {

    static func execute(intent: String) {

        switch intent {

        case "open_google":
            if let url = URL(string: "https://www.google.com") {
                UIApplication.shared.open(url)
            }

        case "open_youtube":
            if let url = URL(string: "https://www.youtube.com") {
                UIApplication.shared.open(url)
            }

        case "open_maps":
            if let url = URL(string: "http://maps.apple.com") {
                UIApplication.shared.open(url)
            }

        case "call_phone":
            if let url = URL(string: "tel://") {
                UIApplication.shared.open(url)
            }

        case "tell_joke":
            print("Why do programmers hate nature? Too many bugs.")

        default:
            print("Unknown command")
        }
    }
}
