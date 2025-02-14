//
//  SettingsView.swift
//  Verismo
//
//  Created by Michał Lisicki on 25/12/2024.
//

import SwiftUI
@preconcurrency import Translation

struct PlaybackSettingsView: View {
    @EnvironmentObject var viewModel: ViewModel
    @AppStorage("lyricsFontSize") var lyricsFontSize: Double = 48.0
    @AppStorage("timerTransition") var timerTransition = true
    
    @Binding var dismissSheet: Bool
    
    var body: some View {
        Form {
#if os(iOS)
            Section(header: Text("Playback")) {
                VStack {
                    Text("Volume: \(Int(viewModel.volume * 100))%")
                        .font(.headline)
                        .accessibilityHidden(true)
                    Slider(value: $viewModel.volume, in: 0...1)
                        .accessibilityLabel("Volume")
                        .accessibilityValue("\(Int(viewModel.volume * 100)) percent")
                }
                Toggle("Timer Transition Animation", isOn: $timerTransition)
            }
            Section(header: Text("Lyrics")) {
                HStack {
                    LanguagePicker(availableLanguages: viewModel.availableLanguages, targetLanguage: $viewModel.targetLanguage)
                    
                    if !viewModel.translationPossible && viewModel.targetLanguage != Locale.Language(languageCode: "en", script: nil, region: "GB") {
                        Image(systemName: "slowmo")
                            .symbolEffect(.variableColor.iterative.dimInactiveLayers.nonReversing, options: .repeat(.continuous))
                            .accessibilityLabel("loading spinner")
                    }
                }
            }
#else
            VStack {
                VStack {
                    Text("Volume: \(Int(viewModel.volume * 100))%")
                        .font(.headline)
                        .accessibilityHidden(true)
                    Slider(value: $viewModel.volume, in: 0...1)
                        .accessibilityLabel("Volume")
                        .accessibilityValue("\(Int(viewModel.volume * 100)) percent")
                }
                .padding(.bottom, 10)
                Toggle("Timer Transition Animation", isOn: $timerTransition)
                    .padding(.bottom, 13)
                Divider()
                VStack(spacing: 15) {
                    Text("Font Size: \(Int(lyricsFontSize))")
                        .font(.headline)
                    Slider(value: $lyricsFontSize, in: 30...48, step: 2)
                        .accessibilityLabel("Lyrics font size")
                        .accessibilityValue("\(Int(lyricsFontSize)) points")
                    HStack {
                        LanguagePicker(availableLanguages: viewModel.availableLanguages, targetLanguage: $viewModel.targetLanguage)
                        
                        if !viewModel.translationPossible && viewModel.targetLanguage != Locale.Language(languageCode: "en", script: nil, region: "GB") {
                            Image(systemName: "slowmo")
                                .symbolEffect(.variableColor.iterative.dimInactiveLayers.nonReversing, options: .repeat(.continuous))
                                .accessibilityLabel("loading spinner")
                        }
                    }
                }
                .padding(.top, 13)
            }
            .padding()
#endif
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Playback Preferences")
    }
}

struct LanguagePicker: View {
    let availableLanguages: [AvailableLanguage]
    @Binding var targetLanguage: Locale.Language
    
    var body: some View {
        HStack {
            Picker("Select Subtitles Language:", selection: $targetLanguage) {
                ForEach(availableLanguages, id: \.locale) { language in
                    Text(language.localizedName()).tag(language.locale)
                }
            }
            .translationTask(TranslationSession.Configuration(source: Locale.Language(languageCode: "en", script: nil, region: "GB"), target: targetLanguage)) { session in
                try? await session.prepareTranslation()
            }
        }
    }
}
