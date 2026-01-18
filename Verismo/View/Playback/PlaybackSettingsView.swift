//
//  SettingsView.swift
//  Verismo
//
//  Created by Michał Lisicki on 25/12/2024.
//

import SwiftUI

struct PlaybackSettingsView: View {
    @Environment(ViewModel.self) var viewModel
    @AppStorage("lyricsFontSize") var lyricsFontSize: Double = 48.0
    @AppStorage("timerTransition") var timerTransition = true
    
    @Binding var dismissSheet: Bool
    
    var body: some View {
      @Bindable var viewModel = viewModel
        Form {
#if os(iOS)
            Section(header: Text("Playback")) {
              VolumeSlider()
              timerTransitionAnimation
            }
            Section(header: Text("Lyrics")) {
              languagePicker
            }
#else
            VStack {
                VolumeSlider()
                    .padding(.bottom, 10)
              timerTransitionAnimation
                    .padding(.bottom, 13)
                Divider()
                VStack(spacing: 15) {
                  fontSize
                  languagePicker
                }
                .padding(.top, 13)
            }
            .padding()
#endif
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Playback Preferences")
    }
  
  private var timerTransitionAnimation: some View {
    Toggle("Timer Transition Animation", isOn: $timerTransition)
  }
  
  private var languagePicker: some View {
    HStack {
      @Bindable var viewModel = viewModel
      LanguagePicker(availableLanguages: viewModel.availableLanguages, targetLanguage: $viewModel.targetLanguage)
      if !viewModel.translationPossible && viewModel.targetLanguage != Locale.Language(languageCode: "en", script: nil, region: "GB") {
        Image(systemName: "slowmo")
          .symbolEffect(.variableColor.iterative.dimInactiveLayers.nonReversing, options: .repeat(.continuous))
          .accessibilityLabel("loading spinner")
      }
    }
  }
  
  @ViewBuilder
  private var fontSize: some View {
    Text("Font Size: \(Int(lyricsFontSize))")
        .font(.headline)
    Slider(value: $lyricsFontSize, in: 30...48, step: 2)
        .accessibilityLabel("Lyrics font size")
        .accessibilityValue("\(Int(lyricsFontSize)) points")
  }
}

private struct VolumeSlider: View {
  @Environment(ViewModel.self) var viewModel
  
  var body: some View {
    @Bindable var viewModel = viewModel
    VStack {
        Text("Volume: \(Int(viewModel.volume * 100))%")
            .font(.headline)
            .accessibilityHidden(true)
        Slider(value: $viewModel.volume, in: 0...1)
            .accessibilityLabel("Volume")
            .accessibilityValue("\(Int(viewModel.volume * 100)) percent")
    }
  }
}


#Preview {
  @Previewable @State var dismiss = false
  PlaybackSettingsView(dismissSheet: $dismiss)
    .environment(ViewModel())
}
