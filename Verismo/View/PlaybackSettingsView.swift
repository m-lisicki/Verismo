//
//  SettingsView.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 25/12/2024.
//

import SwiftUI
import Translation

struct PlaybackSettingsView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var availableLanguages: [AvailableLanguage] = []
        
    var body: some View {
        Form {
            VStack {
                // Lyrics Settings
                Text("Font Size: \(Int(viewModel.lyricsFontSize))")
                Slider(value: $viewModel.lyricsFontSize, in: 30...48, step: 2)
                
                // Playback Settings
                
                Text("Volume: \(Int(viewModel.volume * 100))%")
                Slider(value: $viewModel.volume, in: 0...1)

                // Target Language Picker
                HStack {
                    Picker("Select Subtitles Language:", selection: $viewModel.targetLanguage) {
                        ForEach(viewModel.availableLanguages, id: \.locale) { language in
                            Text(language.localizedName()).tag(language.locale)
                        }
                    }

                    .translationTask(TranslationSession.Configuration(source: Locale.Language(languageCode: "en", script: nil, region: "GB"), target: viewModel.targetLanguage)) { session in
                        try? await session.prepareTranslation()
                    }
                    /*.onSubmit {
                        translationService.translationPossible = false
                    }
                    if !translationService.translationPossible && viewModel.targetLanguage != Locale.Language(languageCode: "en", script: nil, region: "GB") && viewModel.targetLanguage !=  Locale.Language(languageCode: "en", script: nil, region: "US")
                    {
                        Image(systemName: "slowmo")
                        .symbolEffect(.variableColor.iterative.dimInactiveLayers.nonReversing, options: .repeat(.continuous))
                    }*/
                }
                .padding(.top, 7)
            }
        }
        .padding()
        .navigationTitle("Playback Preferences")
    }
}
