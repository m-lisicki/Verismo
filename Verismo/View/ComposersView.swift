//
//  ComposersView.swift
//  Verismo
//
//  Created by Michał Lisicki on 29/12/2024.
//

import SwiftUI

struct ComposersView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State var click = false
    
    var body: some View {
        VStack(spacing: 70) {
            //Text("Select Composer:").fadingText()
            HStack(spacing: 60) {
                ForEach(viewModel.composers.indices, id: \.self) { index in
                    ComposerButton(name: viewModel.composers[index].name, lifespan: viewModel.composers[index].lifespan, imageName: viewModel.composers[index].imageName) {
                        viewModel.chosenComposer = index
                        click.toggle()
                    }
                }
                // Add more ComposerButton instances for other composers...
            }
            .sensoryFeedback(.selection, trigger: click)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Select Composer")
                    .font(.headline)
            }
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
    }
}

