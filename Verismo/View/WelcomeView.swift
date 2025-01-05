//
//  WelcomeView.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 26/12/2024.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var click = false
    
    var body: some View {
        VStack(spacing: 70) {
            Text("Welcome to Verismo.")
                .fadingText()
            HStack(spacing: 25) {
                Button(action: {
                    viewModel.chosenMode = 0
                    click.toggle()
                }) {
                    VStack(spacing: 13) {
                        Image(systemName: "music.note.list")
                            .font(.system(size: 23))
                            .symbolRenderingMode(.hierarchical)
                        Text("Listen")
                            .font(.headline)
                    }
                    .fontWeight(.light)
                    .frame(width: 75, height: 55)
                    .padding()
                }
                .buttonStyle(.borderless)
                .background(.ultraThickMaterial)
                .cornerRadius(5)
                
                Button(action: {
                    viewModel.chosenMode = 1
                }) {
                    VStack(spacing: 13) {
                        Image(systemName: "book.pages")
                            .font(.system(size: 23))
                            .symbolRenderingMode(.hierarchical)
                        Text("Read")
                            .font(.headline)
                    }
                    .fontWeight(.light)
                    .frame(width: 75, height: 55)
                    .padding()
                }
                .buttonStyle(.borderless)
                .background(.ultraThickMaterial)
                .cornerRadius(5)
                .disabled(true)
            }
            .sensoryFeedback(.selection, trigger: click)
        }
        .shadow(radius: 0.5)
    }
}
