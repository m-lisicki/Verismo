//
//  HorizontalButton.swift
//  Verismo
//
//  Created by Michał Lisicki on 18/01/2026.
//

import SwiftUI

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
                Text(LocalizedStringKey(text))
                    .font(.headline)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(LocalizedStringKey(text))
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
                Text(LocalizedStringKey(text))
                    .font(.headline)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(LocalizedStringKey(text))
            .fontWeight(.light)
            .padding()
        }
        .background(.ultraThickMaterial)
        .cornerRadius(5)
        .buttonStyle(.borderless)
    }
}
