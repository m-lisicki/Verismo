//
//  SettingsView.swift
//  Verismo
//
//  Created by Michał Lisicki on 25/12/2024.
//

import SwiftUI
@preconcurrency import Translation

struct PlaybackSettingsView: View {
    @AppStorage("lyricsFontSize") var lyricsFontSize: Double = 48.0
    @AppStorage("timerTransition") private var timerTransition = true
    
    let availableLanguages: [AvailableLanguage]
    @Binding var targetLanguage: Locale.Language
    @Binding var translationPossible: Bool
    @Binding var volume: Double
    
    var body: some View {
        Form {
#if os(iOS)
            Section(header: Text("Playback")) {
                VStack {
                    Text("Volume: \(Int(volume * 100))%")
                        .font(.headline)
                    Slider(value: $volume, in: 0...1)
                        .accessibilityValue("\(Int(volume * 100)) percent")
                }
                Toggle("Timer Transition Animation", isOn: $timerTransition)
            }
            Section(header: Text("Lyrics")) {
                HStack {
                    Picker("Select Subtitles Language:", selection: $targetLanguage) {
                        ForEach(availableLanguages, id: \.locale) { language in
                            Text(language.localizedName()).tag(language.locale)
                        }
                    }
                    .translationTask(TranslationSession.Configuration(source: Locale.Language(languageCode: "en", script: nil, region: "GB"), target: targetLanguage)) { session in
                        try? await session.prepareTranslation()
                    }
                    .onSubmit {
                        translationPossible = false
                    }
                    if !translationPossible && targetLanguage != Locale.Language(languageCode: "en", script: nil, region: "GB")
                    {
                        Image(systemName: "slowmo")
                            .symbolEffect(.variableColor.iterative.dimInactiveLayers.nonReversing, options: .repeat(.continuous))
                    }
                }
            }
            
#else
            VStack {
                VStack {
                    Text("Volume: \(Int(volume * 100))%")
                        .font(.headline)
                    Slider(value: $volume, in: 0...1)
                        .accessibilityValue("\(Int(volume * 100)) percent")
                }
                .padding(.bottom, 10)
                Toggle("Timer Transition Animation", isOn: $timerTransition)
                    .padding(.bottom, 13)
                Divider()
                VStack(spacing: 15) {
                    Text("Font Size: \(Int(lyricsFontSize))")
                        .font(.headline)
                    Slider(value: $lyricsFontSize, in: 30...48, step: 2)
                        .accessibilityValue("\(Int(lyricsFontSize)) points")
                    HStack {
                        Picker("Select Subtitles Language:", selection: $targetLanguage) {
                            ForEach(availableLanguages, id: \.locale) { language in
                                Text(language.localizedName()).tag(language.locale)
                            }
                        }
                        .translationTask(TranslationSession.Configuration(source: Locale.Language(languageCode: "en", script: nil, region: "GB"), target: targetLanguage)) { session in
                            try? await session.prepareTranslation()
                        }
                        if !translationPossible && targetLanguage != Locale.Language(languageCode: "en", script: nil, region: "GB")
                        {
                            Image(systemName: "slowmo")
                                .symbolEffect(.variableColor.iterative.dimInactiveLayers.nonReversing, options: .repeat(.continuous))
                        }
                    }
                }
            }
                .padding(.top, 13)
            .padding()
#endif
        }
        .navigationTitle("Playback Preferences")
    }
}

#Preview {
    @Previewable @StateObject var model = ViewModel()
    PlaybackSettingsView(availableLanguages: model.availableLanguages, targetLanguage: $model.targetLanguage, translationPossible: $model.translationPossible, volume: $model.volume).environmentObject(model)
}
