//
//  ComposerInfoView.swift
//  Verismo
//
//  Created by Michał Lisicki on 17/01/2025.
//
import SwiftUI

struct ComposerReadingView: View {
    @EnvironmentObject var viewModel: ViewModel
    let chosenComposer: ComposerID
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var isPortraitMode: Bool {
#if os(iOS)
        horizontalSizeClass == .compact && verticalSizeClass == .regular
#else
        false
#endif
    }
    
    var body: some View {
        let composerData = composers[chosenComposer.rawValue]
        
        ZStack {
            BackgroundGradient()
            VStack(spacing: 20) {
                if isPortraitMode {
                    ScrollView {
                        ComposerInformationSection(composerData: composerData)
                        
                        InformationSection(title: "Biography", content: composerData.biography)
                            .padding(.horizontal)
                    }.safeAreaInset(edge: .bottom) {
                        VStack {
                            Divider()
                                .padding(.bottom)
                            HorizontalButtonView(chosenComposer: chosenComposer)
                        }
                        .background(.thinMaterial)
                    }
                } else {
                    HStack {
                        ComposerInformationSection(composerData: composerData)
                        
                        VStack {
                            ScrollView {
                                InformationSection(title: "Biography", content: composerData.biography)
                                    .padding()
                            }.safeAreaInset(edge: .bottom) {
                                VStack {
                                    Divider()
                                    HorizontalButtonView(chosenComposer: chosenComposer)
                                    Divider()
                                }
                                .background(.thinMaterial)
                                .cornerRadius(7)
                                .padding(.horizontal)
                            }
                        }
#if os(macOS)
                        .padding(.vertical)
#endif
                    }
                }
            }
#if os(iOS)
            .navigationTitle("\(composerData.firstname) \(composerData.surname)")
            .navigationBarTitleDisplayMode(.large)
#else
            .navigationTitle("Composer")
#endif
        }
    }
}

struct ComposerInformationSection: View {
    let composerData: Composer
    
    var body: some View {
        
        VStack() {
#if os(macOS)
            Text(composerData.surname)
                .fadingText()
            Divider()
                .padding(.bottom, 5)
#endif
            Image(decorative: composerData.surname)
                .resizable()
                .scaledToFit()
                .cornerRadius(7)
                .frame(maxHeight: 250)
                .shadow(radius: 5)
                .padding(.bottom, 4)
            
            VStack() {
                Text(composerData.lifespan)
                    .accessibilityLabel("Lifespan: \(composerData.lifespan)")
                Text(composerData.birthPlace)
                    .accessibilityLabel("Birth place: \(composerData.birthPlace)")
            }
            .font(.footnote)
        }
        .padding()
    }
}

struct HorizontalButtonView: View {
    let chosenComposer: ComposerID
    
    var body: some View {
        HStack(spacing: 25) {
            if chosenComposer != .szymanowski {
                HorizontalButton(text: "Listen", image: "music.note", listenMode: true, chosenComposer: chosenComposer)
            }
            HorizontalButton(text: "Read", image: "book.pages", listenMode: false, chosenComposer: chosenComposer)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct HorizontalButton: View {
    let text: String
    let image: String
    let listenMode: Bool
    let chosenComposer: ComposerID
    
    var body: some View {
        NavigationLink(destination: OperasView(listenMode: listenMode, chosenComposer: chosenComposer)){
            HStack(spacing: 13) {
                Image(systemName: image)
                    .font(.title3)
                    .symbolRenderingMode(.hierarchical)
                Text(text)
                    .font(.headline)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(text)
            .fontWeight(.light)
            .frame(maxHeight: .infinity)
            .padding()
            .accessibilityLabel(text)
        }
        .background(.ultraThickMaterial)
        .cornerRadius(5)
        .buttonStyle(.borderless)
    }
}

struct HorizontalButtonViewPlayback: View {
    let text: String
    let image: String
    let recording: Recording
    
    var body: some View {
        NavigationLink(destination: PickOperaView(chosenRecording: recording)){
            HStack(spacing: 13) {
                Image(systemName: image)
                    .font(.title3)
                    .symbolRenderingMode(.hierarchical)
                Text(text)
                    .font(.headline)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(text)
            .fontWeight(.light)
            .padding()
        }
        .background(.ultraThickMaterial)
        .cornerRadius(5)
        .buttonStyle(.borderless)
    }
}

#Preview {
    @Previewable @StateObject var viewModel = ViewModel()
    ComposerReadingView(chosenComposer: .puccini).environmentObject(viewModel)
}
