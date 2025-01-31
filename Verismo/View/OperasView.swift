//
//  OperasView.swift
//  Verismo
//
//  Created by Michał Lisicki on 29/12/2024.
//

import SwiftUI

struct OperasView: View {
    let listenMode: Bool
    let chosenComposer: ComposerID
    
    var body: some View {
        ZStack {
            BackgroundGradient()
            VStack(spacing: 70) {
                ComposerOperasView(
                    listenMode: listenMode,
                    chosenComposer: chosenComposer
                )
            }
            .buttonStyle(.plain)
            .navigationTitle("Choose Your Opera")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
        }
    }
}

struct ComposerOperasView: View {
    let listenMode: Bool
    let chosenComposer: ComposerID
    
    var body: some View {
        OperaGridView(
            listenMode: listenMode,
            chosenComposer: chosenComposer
        )
    }
}

struct OperaGridView: View {
    let listenMode: Bool
    let chosenComposer: ComposerID
    @Namespace var transitionNamespace
    
    var filteredOperas: [Opera] {
        operas.filter { $0.composerID == chosenComposer}
    }
    
    @ViewBuilder
    func destinationView(for opera: Opera) -> some View {
        if listenMode {
            PickOperaView(chosenOpera: opera.operaID)
        } else {
            OperaReadingView(chosenComposer: chosenComposer, chosenOpera: opera)
        }
    }
    
    var body: some View {
        HStack(spacing: 35) {
            ForEach(filteredOperas) { opera in
                NavigationLink(destination: destinationView(for: opera)
                               #if os(iOS)
                    .navigationTransition(
                        .zoom(sourceID: opera.title, in: transitionNamespace))
                               #endif
                ) {
                    OperaFrame(title: opera.title, year: opera.premiereDate)
                }
            }
        }
    }
}



struct OperaFrame: View {
    let title: String
    let year: Date
    
    @State var isHovered = false
    @State var opacity = 0.0
    @Namespace var transitionNamespace
    
    let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack {
            Image(decorative: title)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 210)
                .cornerRadius(5)
                .clipped()
                .scaleEffect(isHovered ? 1.25 : 1)
#if os(iOS)
                .matchedTransitionSource(id: title, in: transitionNamespace)
#endif
            VStack {
                Text(title)
                    .font(.title3)
                Text(year, formatter: dateFormatter)
                    .font(.subheadline)
            }
            .fontDesign(.serif)
            .offset(y: isHovered ? 25: 0)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(year, formatter: dateFormatter)")
        .animation(.spring(duration: 1), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
