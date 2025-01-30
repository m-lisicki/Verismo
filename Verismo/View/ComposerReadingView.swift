//
//  ComposerInfoView.swift
//  Verismo
//
//  Created by Michał Lisicki on 17/01/2025.
//
import SwiftUI

struct ComposerReadingView: View {
    @EnvironmentObject var viewModel: ViewModel
    let chosenComposer: composerID
    
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var isPortraitMode: Bool {
#if os(iOS)
        horizontalSizeClass == .compact && verticalSizeClass == .regular || horizontalSizeClass == .regular && verticalSizeClass == .regular
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
                        VStack() {
                            Image(composerData.surname)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(7)
                                .frame(maxHeight: 250)
                                .shadow(radius: 10)
                                .padding(.bottom, 4)
                            VStack() {
                                // Lifespan
                                Text(composerData.lifespan)
                                Text(composerData.birthPlace)
                            }
                            .font(.footnote)
                        }
                        .padding()
                        
                        
                        InformationSection(title: "Biography", content: composerData.biography)
                            .padding(.horizontal)
                    }
                    Divider()
                        .padding([.leading, .bottom, .trailing])
                    
                    // Navigation to Operas View
                    HStack(spacing: 25) {
                        HorizontalButtonView(text: "Listen", image: "music.note", listenMode: true, chosenComposer: chosenComposer)
                        HorizontalButtonView(text: "Read", image: "book.pages", listenMode: false, chosenComposer: chosenComposer)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom)
                } else {
                    HStack {
                        VStack() {
#if os(macOS)
                            Text(composerData.surname)
                                .fadingText()
                            Divider()
                                .padding(.bottom, 5)
#endif
                            Image(composerData.surname)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(7)
                                .frame(maxHeight: 250)
                                .shadow(radius: 10)
                            
                            VStack() {
                                // Lifespan
                                Text(composerData.lifespan)
                                Text(composerData.birthPlace)
                            }
                            .font(.footnote)
                        }
                        .padding()
                        
                        VStack {
                            ScrollView {
                                InformationSection(title: "Biography", content: composerData.biography)
                                    .padding()
                            }
                            
                            
                            
                            VStack {
                                Divider()
                                    .padding([.leading, .bottom, .trailing])
                                // Navigation to Operas View
                                HStack(spacing: 25) {
                                    HorizontalButtonView(text: "Listen", image: "music.note", listenMode: true, chosenComposer: chosenComposer)
                                    HorizontalButtonView(text: "Read", image: "book.pages", listenMode: false, chosenComposer: chosenComposer)
                                }
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom)
                            }
                        }
#if os(macOS)
                        .padding(.vertical)
#endif
                    }
                }
            }
#if os(iOS)
            .navigationTitle("\(composerData.firstname)  \(composerData.surname)")
            .navigationBarTitleDisplayMode(.large)
#else
            .navigationTitle("Composer")
#endif
        }
    }
}

struct HorizontalButtonView: View {
    let text: String
    let image: String
    let listenMode: Bool
    let chosenComposer: composerID
    
    var body: some View {
        NavigationLink(destination: OperasView(listenMode: listenMode, chosenComposer: chosenComposer)){
            HStack(spacing: 13) {
                Image(systemName: image)
                    .font(.title3)
                    .symbolRenderingMode(.hierarchical)
                Text(text)
                    .font(.headline)
            }
            .fontWeight(.light)
            .frame(maxHeight: .infinity)
            .padding()
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
        NavigationLink(destination: PlaybackView(recording: recording)){
            HStack(spacing: 13) {
                Image(systemName: image)
                    .font(.title3)
                    .symbolRenderingMode(.hierarchical)
                Text(text)
                    .font(.headline)
            }
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
