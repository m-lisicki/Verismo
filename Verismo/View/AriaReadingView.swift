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
        ZStack {
            BackgroundGradient()
            if isPortraitMode {
                VStack(spacing: 20) {
                    ScrollView {
                        VStack() {
                            Image(aria.imageName)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(7)
                                .frame(maxHeight: 250)
                                .shadow(radius: 10)
                            Text(aria.mainCharacter)
                                .font(.footnote)
                        }
                        .padding()
                        InformationSection(title: "Context", content: aria.background)
                            .padding(.horizontal)
                    }
                    if let index = aria.recordingID {
                        Divider()
                            .padding([.leading, .bottom, .trailing])
                        HorizontalButtonViewPlayback(text: "Listen", image: "music.note", recording: viewModel.recordings[index])
                            .padding(.bottom)
                    }
                }
            } else {
                HStack {
                    VStack() {
#if os(macOS)
                        Text(aria.title)
                            .fadingText()
#endif
                        Text(aria.mainCharacter)
#if os(macOS)
                            .font(.caption)
#else
                            .font(.headline)
#endif
                        Divider()
                        
                        
                        Image(aria.imageName)
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
                    VStack {
                        ScrollView {
                            InformationSection(title: "Context", content: aria.background)
                                .padding()
                        }
                        VStack {
                            if let index = aria.recordingID {
                                Divider()
                                    .padding([.leading, .bottom, .trailing])
                                HorizontalButtonViewPlayback(text: "Listen", image: "music.note", recording: viewModel.recordings[index])
                                    .padding(.bottom)
                            }
                        }
#if os(macOS)
                        .padding(.vertical)
#endif
                        
                    }
                    
                }
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
    //@Previewable @StateObject var model = ViewModel()
    //AriaReadingView(aria: composers[composerID.puccini.rawValue].operas[0].arias[3]).environmentObject(model)
}
