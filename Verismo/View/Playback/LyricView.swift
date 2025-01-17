//
//  LyricView.swift
//  Verismo
//
//  Created by Michał Lisicki on 25/12/2024.
//

import SwiftUI
@preconcurrency import Translation

struct LyricView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var configuration: TranslationSession.Configuration?
    @State private var targetText = ""
    
    @AppStorage("lyricsFontSize") var lyricsFontSize: Double = 48.0
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(viewModel.currentSinger)
                .font(.system(size: lyricsFontSize - 10))
                .padding(.top)
            
            Text(viewModel.currentLyric)
                .font(.system(size: lyricsFontSize))
                .fontWeight(.light)
                .fontDesign(.serif)
                .italic()
                .padding()
            
            Text(targetText)
                .font(.system(size: lyricsFontSize - 13))
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(7)
                .opacity(viewModel.currentTranslation.isEmpty ? 0 : 1)
                .translationTask(configuration) { session in
                    let response = try? await session.translate(viewModel.currentTranslation)
                    targetText = response?.targetText ?? viewModel.currentTranslation
                }
        }
        .padding()
        .onChange(of: viewModel.translationPossible) { _, newValue in
            if newValue && !viewModel.currentTranslation.isEmpty {
                triggerTranslation()
            }
        }
        .onChange(of: viewModel.currentTranslation) {
            if viewModel.translationPossible && !viewModel.tempSneezeTranslation && !viewModel.currentTranslation.isEmpty {
                triggerTranslation()
            } else {
                targetText = viewModel.currentTranslation
            }
        }
        .onChange(of: viewModel.targetLanguage) { oldValue, newValue in
            viewModel.translationPossible = false
            configuration?.invalidate()
            configuration = TranslationSession.Configuration(source: Locale.Language(languageCode: "en", region: "GB"), target: viewModel.targetLanguage)
            Task {
                await viewModel.checkLanguageAvailability()
            }
        }
    }
    
    private func triggerTranslation() {
        guard configuration == nil else {
            configuration?.invalidate()
            return
        }
        configuration = TranslationSession.Configuration(source: Locale.Language(languageCode: "en",region: "GB"),
                                                         target: viewModel.targetLanguage)
    }
}
