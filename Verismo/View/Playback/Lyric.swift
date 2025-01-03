//
//  LyricView.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 25/12/2024.
//

import SwiftUI
import Translation

struct Lyric: View {
    let currentSinger: String
    let currentLyric: String
    let englishTranslation: String
    let fontSize: Double
    let resetPlayback: () -> Void
    
    @Environment(TranslationService.self) var translationService
    
    @State var configuration: TranslationSession.Configuration?
    let targetLanguage: Locale.Language
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(currentSinger)
                .font(.system(size: fontSize - 10))
                .padding(.top)
                .italic()
            
            Text(currentLyric)
                .font(.system(size: fontSize))
                .fontWeight(.light)
                .fontDesign(.serif)
                .italic()
                .padding()
            
            Text(translationService.translatedText)
                .font(.system(size: fontSize - 13))
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(7)
                .opacity(englishTranslation.isEmpty ? 0 : 1)
                .onDisappear {
                    print("Boing")
                    configuration?.invalidate()
                }
                .translationTask(configuration) { session in
                    do {
                        try await translationService.translate(
                            text: englishTranslation,
                            using: session)
                    } catch {
                        translationService.translatedText = ""
                    }
                }
        }
        .padding()
        .onAppear {
            checkLanguageAvailability()
        }
        .onChange(of: englishTranslation) {
            if translationService.translationPossible && !englishTranslation.isEmpty {
                triggerTranslation()
            } else {
                translationService.translatedText = englishTranslation
            }
        }
        .onChange(of: targetLanguage) { oldValue, newValue in
            if (oldValue != newValue) {
                translationService.translationPossible = false
                configuration?.invalidate()
                configuration = TranslationSession.Configuration(source: Locale.Language(languageCode: "en", region: "GB"), target: targetLanguage)
                checkLanguageAvailability()
            }
        }
    }
    
    let availability = LanguageAvailability()
    func checkLanguageAvailability() {
        Task {
            let status = await availability.status(from: Locale.Language(languageCode: "en", region: "GB"), to: targetLanguage)
            if status == .installed {
                translationService.translationPossible = true
            } else if status == .supported {
                DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                    //Checks to automaticaly switch to new translation if user downloads translation
                    checkLanguageAvailability()
                }
            }
        }
    }
    
    func triggerTranslation() {
        if configuration == nil {
            configuration = TranslationSession.Configuration(source: Locale.Language(languageCode: "en",region: "GB"),
            target: targetLanguage)
        } else {
            configuration?.invalidate()
        }
    }
}

