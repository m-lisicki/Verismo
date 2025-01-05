//
//  LyricView.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 25/12/2024.
//

import SwiftUI
import Translation

struct LyricView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var targetText = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(viewModel.currentSinger)
                .font(.system(size: viewModel.lyricsFontSize - 10))
                .padding(.top)
            
            Text(viewModel.currentLyric)
                .font(.system(size: viewModel.lyricsFontSize))
                .fontWeight(.light)
                .fontDesign(.serif)
                .italic()
                .padding()
            
            Text(targetText)
                .font(.system(size: viewModel.lyricsFontSize - 13))
                .padding()
                .background(Color.gray.opacity(0.3))
                .cornerRadius(7)
                .opacity(viewModel.currentTranslation.isEmpty ? 0 : 1)
                .onDisappear {
                    print("Boing")
                    viewModel.configuration?.invalidate()
                }
                .translationTask(viewModel.configuration) { session in
                    do {
                        let response = try await session.translate(viewModel.currentTranslation)
                        targetText = response.targetText
                    } catch {
                        //Errors
                    }
                }
        }
        .padding()
        .onChange(of: viewModel.currentTranslation) {
            if viewModel.translationPossible && !viewModel.currentTranslation.isEmpty {
                triggerTranslation()
            } else {
                targetText = viewModel.currentTranslation
            }
        }
        .onChange(of: viewModel.targetLanguage) { oldValue, newValue in
            if (oldValue != newValue) {
                viewModel.translationPossible = false
                viewModel.configuration?.invalidate()
                viewModel.configuration = TranslationSession.Configuration(source: Locale.Language(languageCode: "en", region: "GB"), target: viewModel.targetLanguage)
                Task {
                    await viewModel.checkLanguageAvailability()
                }
            }
        }
    }
    
    private func triggerTranslation() {
        guard viewModel.configuration == nil else {
            viewModel.configuration?.invalidate()
            return
        }
        
        viewModel.configuration = TranslationSession.Configuration(source: Locale.Language(languageCode: "en",region: "GB"),
                                                             target: viewModel.targetLanguage)
    }
}
