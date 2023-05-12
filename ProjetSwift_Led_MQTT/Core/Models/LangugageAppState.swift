//
//  LangugageAppState.swift
//  ProjetSwift_Led_MQTT
//
//  Created by Enzo on 2023-05-11.
//

import Combine
import Foundation

class LanguageAppState: ObservableObject {
    @Published var appLanguage: String = ""

    func setAppLanguage(language: String) {
        appLanguage = language
    }
}
