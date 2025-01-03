//
//  SwiftUIView.swift
//  Verismo
//
//  Created by Michał Lisicki on 29/12/2024.
//

import SwiftUI

struct Composers: View {
    @Binding var chosenComposer: Int?
    @State var click = false

    
    var body: some View {
        VStack(spacing: 70) {
            Text("Select composer:")
                .fadingText()
            HStack(spacing: 65) {
                ComposerButton(name: "Verdi", lifespan: "1813–1901", imageName: "Verdi") {
                    chosenComposer = 0
                    click.toggle()
                }
                .disabled(true)

                
                ComposerButton(name: "Puccini", lifespan: "1858–1924", imageName: "Puccini") {
                    chosenComposer = 1
                    click.toggle()
                }
                
                // Add more ComposerButton instances for other composers...
            }
            .sensoryFeedback(.selection, trigger: click)
        }
    }
}

struct ComposerButton: View {
    var name: String
    var lifespan: String
    var imageName: String
    var action: () -> Void
    
    @State private var isHovered = false
    @State private var opacity = 0.0
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 190)
                    .cornerRadius(5)
                    .clipped()
                    .scaleEffect(isHovered ? 1.25 : 1)
                VStack {
                    Text(name)
                        .font(.title3)
                    Text(lifespan)
                        .font(.subheadline)
                }
                .fontDesign(.serif)
                .offset(y: isHovered ? 25: 0)
            }
            .animation(.spring(duration: 1), value: isHovered)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
        /*.opacity(opacity)
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                opacity = 1.0
            }
        }*/
    }
}

