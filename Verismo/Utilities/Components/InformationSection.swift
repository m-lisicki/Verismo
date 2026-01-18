//
//  InformationSection.swift
//  Verismo
//
//  Created by Michał Lisicki on 18/01/2026.
//

import SwiftUI
import Translation

struct InformationSection: View {
  @Environment(ViewModel.self) var viewModel
    @State var configuration: TranslationSession.Configuration?
    
    let title: String
    let content: String
    @State var previousTargetLanguage: Locale.Language?
    @State var targetTitle: String?
    @State var targetContent: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(targetTitle ?? title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .fontDesign(.serif)
                    .translationTask(configuration) { session in
                      Task { @MainActor in
                        let response = try? await session.translate(title)
                        targetTitle = response?.targetText
                      }
                        
                    }
                Spacer()
            }
            Divider()
            Text(targetContent ?? content)
                .font(.body)
                .padding(.top, 5)
                .translationTask(configuration) { session in
                  Task { @MainActor in
                    let response = try? await session.translate(content)
                    targetContent = response?.targetText
                  }
                }
        }
        .accessibilityElement(children: .combine)
        .padding()
        .background()
        .cornerRadius(7)
        .padding(.vertical, 5)
        .onChange(of: viewModel.translationPossible, initial: true) { _, newValue in
            targetTitle = nil
            targetContent = nil
            
            if newValue {
                triggerTranslation()
            }
        }
    }
    
    
    func triggerTranslation() {
        guard configuration == nil || viewModel.targetLanguage != previousTargetLanguage else {
            configuration?.invalidate()
            return
        }
        
        previousTargetLanguage = viewModel.targetLanguage
        configuration = TranslationSession.Configuration(source: Locale.Language(languageCode: "en", script: nil, region: "GB"), target: viewModel.targetLanguage)
    }
}
