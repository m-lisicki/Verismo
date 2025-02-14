//
//  AriaReadingView.swift
//  Verismo
//
//  Created by Michał Lisicki on 19/01/2025.
//
import SwiftUI

struct AriaReadingView: View {
    @EnvironmentObject var viewModel: ViewModel
    let aria: Aria
    
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
        ZStack {
            BackgroundGradient()
            if isPortraitMode {
                ScrollView {
                    VStack(spacing: 10) {
                        Text("Character: \(aria.mainCharacter)")
                            .font(.headline)
                        Image(decorative: aria.imageName)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(7)
                            .shadow(radius: 10)
                        
                        Divider()
                        
                        InformationSection(title: "Context", content: aria.background)
                    }
                    .padding()
                }
                .safeAreaInset(edge: .bottom) {
                    if let index = aria.recordingID {
                        VStack {
                            Divider()
                                .padding(.bottom)
                            HorizontalButtonViewPlayback(text: "Listen", image: "music.note", recording: viewModel.recordings[index])
                                .padding(.bottom)
                        }
                        .background(.thinMaterial)
                    }
                }
            } else {
                HStack {
                    VStack {
#if os(macOS)
                        Text(aria.title)
                            .fadingText()
#endif
                        Text("Character: \(aria.mainCharacter)")
#if os(macOS)
                            .font(.caption)
#else
                            .font(.headline)
#endif
                        
                        Divider()
                        
                        Image(decorative: aria.imageName)
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
                        InformationSection(title: "Context", content: aria.background)
                            .padding()
                    }.safeAreaInset(edge: .bottom) {
                        VStack {
                            if let index = aria.recordingID {
                                VStack {
                                    Divider()
                                    HorizontalButtonViewPlayback(text: "Listen", image: "music.note", recording: viewModel.recordings[index])
                                    Divider()
                                }
                                .background(.thinMaterial)
                                .cornerRadius(7)
                                .padding(.horizontal)
                            }
                        }
                    }
#if os(macOS)
                    .padding(.vertical)
#endif
                }
            }
        }
        .toolbar {
            ToolbarItem {
                LanguagePickerForText()
            }
        }
#if os(iOS)
        .navigationTitle(aria.title)
        .navigationBarTitleDisplayMode(.large)
#else
        .navigationTitle("Aria")
#endif
    }
}


#Preview {
    @Previewable @StateObject var viewModel = ViewModel()
    NavigationStack {
        
        AriaReadingView(aria: arias[1]).environmentObject(viewModel)
    }
}
