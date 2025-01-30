//
//  OperasView.swift
//  Verismo
//
//  Created by Michał Lisicki on 29/12/2024.
//

import SwiftUI

struct OperasView: View {
    let listenMode: Bool
    let chosenComposer: composerID
    
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
            .navigationTitle("Choose an Opera")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
        }
    }
}

// MARK: - Subviews
struct ComposerOperasView: View {
    let listenMode: Bool
    let chosenComposer: composerID
    
    var body: some View {
        OperaGridView(
            listenMode: listenMode,
            chosenComposer: chosenComposer
        )
    }
}

struct OperaGridView: View {
    let listenMode: Bool
    let chosenComposer: composerID
    @Namespace private var transitionNamespace
    
    var filteredOperas: [Opera] {
        operas.filter { $0.composerID == chosenComposer}
    }
    
    var body: some View {
        HStack(spacing: 35) {
            ForEach(filteredOperas) { opera in
                if listenMode {
                    NavigationLink(destination: PickOperaView(chosenOpera: opera.operaID)
                                   #if os(iOS)
                        .navigationTransition(
                            .zoom(sourceID: opera.title, in: transitionNamespace))
                                   #endif
                    ) {
                        OperaFrame(title: opera.title, year: opera.premiereDate)
                    }
                } else {
                    NavigationLink(destination: OperaReadingView(chosenComposer: chosenComposer, chosenOpera: opera)
                                   #if os(iOS)
                        .navigationTransition(.zoom(sourceID: opera.title, in: transitionNamespace))
                                   #endif
                    ) {
                        OperaFrame(title: opera.title, year: opera.premiereDate)
                    }
                }
            }
        }
    }
}



struct OperaFrame: View {
    let title: String
    let year: Date
    
    @State private var isHovered = false
    @State private var opacity = 0.0
    @Namespace private var transitionNamespace
    
    private let dateFormatter: () -> DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }
    
    var body: some View {
        VStack {
            Image(title)
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
                Text(year, formatter: dateFormatter())
                    .font(.subheadline)
            }
            .fontDesign(.serif)
            .offset(y: isHovered ? 25: 0)
        }
        .animation(.spring(duration: 1), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
