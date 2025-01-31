//
//  ComposersMapView.swift
//  Verismo
//
//  Created by Michał Lisicki on 17/01/2025.
//

import SwiftUI
import MapKit

struct ComposersMapView: View {
    @Namespace var transitionNamespace
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOver
    
    var body: some View {
        if !voiceOver {
            ZStack {
                Map() {
                    ForEach(composers) { composer in
                        Annotation("\(composer.firstname) \(composer.surname)", coordinate: composer.birthCoordinates) {
                            NavigationLink(destination: ComposerReadingView(chosenComposer: composer.composerID)
                                           #if os(iOS)
                                .navigationTransition(.zoom(sourceID: composer.id, in: transitionNamespace))
                                           #endif
                            ) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke(.primary, lineWidth: 3)
                                    Image(decorative: composer.surname)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 45)
                                        .cornerRadius(3)
                                        .padding(1)
                                }
                                .matchedTransitionSource(id: composer.id, in: transitionNamespace)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
            }
            .navigationTitle("Composers Map")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
        } else {
            ZStack {
                BackgroundGradient()
                List(composers) { composer in
                    NavigationLink(destination: ComposerReadingView(chosenComposer: composer.composerID)) {
                        Text("\(composer.firstname) \(composer.surname)")
                            .font(.headline)
                            .accessibilityLabel("\(composer.firstname) \(composer.surname)")
                    }
                    .padding()
                }
                .background(.thinMaterial)
                .cornerRadius(7)
                .padding()
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Choose Your Composer")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
        }
    }
}

#Preview {
    ComposersMapView()
}
