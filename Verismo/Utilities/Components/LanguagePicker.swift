//
//  LanguagePicker.swift
//  Verismo
//
//  Created by Michał Lisicki on 18/01/2026.
//

import SwiftUI
import Translation

struct LanguagePicker: View {
    let availableLanguages: [AvailableLanguage]
    @Binding var targetLanguage: Locale.Language
    
    var body: some View {
        HStack {
            Picker("Select Subtitles Language:", selection: $targetLanguage) {
                ForEach(availableLanguages, id: \.locale) { language in
                    Text(language.localizedName).tag(language.locale)
                }
            }
            .translationTask(TranslationSession.Configuration(source: Locale.Language(languageCode: "en", script: nil, region: "GB"), target: targetLanguage)) { session in
              Task { @MainActor in
                try? await session.prepareTranslation()
              }
            }
        }
    }
}
