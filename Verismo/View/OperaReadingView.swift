//
//  ReadingView.swift
//  Verismo
//
//  Created by Michał Lisicki on 17/01/2025.
//

import SwiftUI

struct InformationSection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .fontDesign(.serif)
                Spacer()
            }
            Divider()
            Text(content)
                .font(.body)
                .padding(.top, 5)
        }
        .accessibilityElement(children: .combine)
        .padding()
        .background()
        .cornerRadius(7)
        .padding(.vertical, 5)
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


#Preview {
    @Previewable @StateObject var model = ViewModel()
    OperaReadingView(chosenComposer: .puccini, chosenOpera: operas[0])
        .environmentObject(model)
}
