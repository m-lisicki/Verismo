//
//  SettingsView.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 25/12/2024.
//

import SwiftUI
import Translation

struct PlaybackSettingsView: View {
    @AppStorage("lyricsFontSize") var lyricsFontSize: Double = 48.0
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        Form {
            VStack {
                // Section for Lyrics Settings
                VStack {
                    Text("Volume: \(Int(viewModel.volume * 100))%")
                        .font(.headline)
                    Slider(value: $viewModel.volume, in: 0...1)
                        .accessibilityValue("\(Int(viewModel.volume * 100)) percent")
                }
                .padding(.bottom, 20)
                
                VStack(spacing: 15) {
                    Text("Font Size: \(Int(lyricsFontSize))")
                        .font(.headline)
                    Slider(value: $lyricsFontSize, in: 30...48, step: 2)
                        .accessibilityValue("\(Int(lyricsFontSize)) points")
                    
                    Picker("Select Subtitles Language:", selection: $viewModel.targetLanguage) {
                        ForEach(viewModel.availableLanguages, id: \.locale) { language in
                            Text(language.localizedName()).tag(language.locale)
                        }
                    }
#if os(iOS)
                    .onAppear {
                        viewModel.stopTimer()
                    }
                    .onDisappear {
                        viewModel.startTimer()
                    }
#endif
                }
            }
        }
        .padding()
        .navigationTitle("Playback Preferences")
    }
}

#Preview {
    @Previewable @StateObject var model = ViewModel()
    PlaybackSettingsView().environmentObject(model)
}
