//
//  WelcomeView.swift
//  Verismo
//
//  Created by Michał Lisicki on 26/12/2024.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 70) {
            Text("Welcome to Verismo.")
                .fadingText()
            HStack(spacing: 25) {
                NavigationLink(destination: ComposersView()) {
                    VStack(spacing: 13) {
                        Image(systemName: "book.pages")
                            .font(.system(size: 23))
                            .symbolRenderingMode(.hierarchical)
                        Text("List")
                            .font(.headline)
                    }
                    .fontWeight(.light)
                    .frame(width: 75, height: 55)
                    .padding()
                }
                .disabled(true)
                .buttonStyle(.borderless)
                .background(.ultraThickMaterial)
                .cornerRadius(5)
                
                NavigationLink(destination: ComposersMapView()){
                    VStack(spacing: 13) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 23))
                            .symbolRenderingMode(.hierarchical)
                        Text("Map")
                            .font(.headline)
                    }
                    .fontWeight(.light)
                    .frame(width: 75, height: 55)
                    .padding()
                }
                .buttonStyle(.borderless)
                .background(.ultraThickMaterial)
                .cornerRadius(5)
            }
        }
        .shadow(radius: 0.5)
    }
}
