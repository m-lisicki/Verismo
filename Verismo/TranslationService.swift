//
//  TranslationService.swift
//  Verismo
//
//  Created by Michał Lisicki on 30/12/2024.
//

import Foundation
import Translation

@Observable
class TranslationService {
    var translatedText = ""
    var translationPossible = false
    var availableLanguages: [AvailableLanguage] = []
    
    init() {
        fetchAvailableLanguages()
    }
    
    func fetchAvailableLanguages() {
        Task {
            let languages = await LanguageAvailability().supportedLanguages
            availableLanguages = languages.map { AvailableLanguage(locale: $0)}
                .filter { language in
                    let shortName = language.shortName()
                    return shortName != "it" && shortName != "en-US"
                }
                .sorted()
        }
    }
    
    func translate(text: String, using session: TranslationSession) async throws {
        let response = try await session.translate(text)
        translatedText = response.targetText
    }
}
