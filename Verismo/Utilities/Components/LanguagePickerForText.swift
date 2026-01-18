//
//  LanguagePickerForText.swift
//  Verismo
//
//  Created by Michał Lisicki on 18/01/2026.
//

import SwiftUI

struct LanguagePickerForText : View {
  @Environment(ViewModel.self) var viewModel: ViewModel

    var body: some View {
      @Bindable var viewModel = viewModel
#if os(macOS)
        LanguagePicker(availableLanguages: viewModel.availableLanguages, targetLanguage: $viewModel.targetLanguage)
#else
        Menu(content: {
            Picker("Select Language:", selection: $viewModel.targetLanguage) {
                ForEach(viewModel.availableLanguages, id: \.locale) { language in
                    Text(language.localizedName()).tag(language.locale)
                }
            }
        },
             label: { Label ("Select Language:", systemImage: "translate")}
        )
        .translationTask(TranslationSession.Configuration(source: Locale.Language(languageCode: "en", script: nil, region: "GB"), target: viewModel.targetLanguage)) { session in
                try? await session.prepareTranslation()
        }
#endif
    }
}
