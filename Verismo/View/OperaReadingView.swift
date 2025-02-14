//
//  ReadingView.swift
//  Verismo
//
//  Created by Michał Lisicki on 17/01/2025.
//

import SwiftUI
@preconcurrency import Translation

struct InformationSection: View {
    @EnvironmentObject var viewModel: ViewModel
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
                        let response = try? await session.translate(title)
                        targetTitle = response?.targetText
                        
                    }
                Spacer()
            }
            Divider()
            Text(targetContent ?? content)
                .font(.body)
                .padding(.top, 5)
                .translationTask(configuration) { session in
                    let response = try? await session.translate(content)
                    targetContent = response?.targetText
                }
        }
        .accessibilityElement(children: .combine)
        .padding()
        .background()
        .cornerRadius(7)
        .padding(.vertical, 5)
        .onChange(of: viewModel.translationPossible) { _, newValue in
            targetTitle = nil
            targetContent = nil
            
            if newValue {
                triggerTranslation()
            }
        }
        .onAppear {
            if viewModel.translationPossible {
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

struct LanguagePickerForText : View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
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

#Preview {
    @Previewable @StateObject var model = ViewModel()
    
    NavigationStack {
        ComposerReadingView(chosenComposer: .puccini)
            .environmentObject(model)
    }
}


struct OperaReadingView: View {
    @EnvironmentObject var viewModel: ViewModel
    let chosenComposer: ComposerID
    let chosenOpera: Opera
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var isPortraitMode: Bool {
#if os(iOS)
        horizontalSizeClass == .compact && verticalSizeClass == .regular
#else
        false
#endif
    }
    
    @State var shouldTranslate = false
    static let dateFormatter: () -> DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            
            if isPortraitMode {
                ScrollView {
                    VStack(spacing: 10) {
                        Text("Premiere: \(chosenOpera.premiereDate, formatter: OperaReadingView.dateFormatter())")
                            .font(.headline)
                        Image(decorative: chosenOpera.coverImageName)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(7)
                            .shadow(radius: 10)
                        
                        Divider()
                        
                        InformationSection(title: "Background", content: chosenOpera.background)
                        InformationSection(title: "Synopsis", content: chosenOpera.synopsis)
                        InformationSection(title: "Music Insights", content: chosenOpera.musicInsights)
                        
                        
                        Divider()
                        
                        AriaScrollView(chosenOpera: chosenOpera)
                    }
                    .padding()
                }
            } else {
                HStack {
                    VStack {
#if os(macOS)
                        Text(chosenOpera.title)
                            .fadingText()
#endif
                        Text("Premiere: \(chosenOpera.premiereDate, formatter: OperaReadingView.dateFormatter())")
#if os(macOS)
                            .font(.caption)
#else
                            .font(.headline)
#endif
                        Divider()
                        Image(decorative: chosenOpera.coverImageName)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(7)
                            .shadow(radius: 10)
#if os(macOS)
                            .padding()
#else
                            .padding(.top)
#endif
                    }
                    .padding()
                    
                    ScrollView {
                        InformationSection(title: "Background", content: chosenOpera.background)
                        InformationSection(title: "Synopsis", content: chosenOpera.synopsis)
                        InformationSection(title: "Music Insights", content: chosenOpera.musicInsights)
                        
                        
                        Divider()
                        
                        AriaScrollView(chosenOpera: chosenOpera)
                    }
                    .padding()
                }
            }
        }
        .toolbar {
            ToolbarItem {
                LanguagePickerForText()
            }
        }
#if os(iOS)
        .navigationTitle(chosenOpera.title)
        .navigationBarTitleDisplayMode(.large)
#else
        .navigationTitle("Opera")
#endif
    }
}

struct AriaScrollView : View {
    @Namespace var transitionNamespace
    
    let chosenOpera: Opera
    var filteredArias: [Aria] {
        arias.filter { $0.operaID == chosenOpera.operaID}
    }
    
    var body: some View {
        if !filteredArias.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text("Famous Arias")
                    .font(.title2.bold())
                    .accessibilityAddTraits(.isHeader)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(filteredArias, id: \.title) { aria in
                            NavigationLink(destination: AriaReadingView(aria: aria)
                                           #if os(iOS)
                                .navigationTransition(.zoom(sourceID: aria.ariaID, in: transitionNamespace))
                                           #endif
                            )
                            {
                                HStack(spacing: 10) {
                                    Image(decorative: aria.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(7)
                                        .frame(maxHeight: 101)
#if os(iOS)
                                        .matchedTransitionSource(id: aria.ariaID, in: transitionNamespace)
#endif
                                    
                                    VStack(alignment: .leading) {
                                        Text(aria.title)
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .fontDesign(.serif)
                                        
                                        Text("Singer: \(aria.mainCharacter)")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                        
                                    }
                                }
                                .padding(15)
                                .background()
                                .cornerRadius(7)
                                .padding(.vertical, 5)
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("\(aria.title), sung by \(aria.mainCharacter)")
                                
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
    }
}

