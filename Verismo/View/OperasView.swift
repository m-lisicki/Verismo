//
//  OperasView.swift
//  Verismo
//
//  Created by Michał Lisicki on 29/12/2024.
//

import SwiftUI

struct OperasView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    
    var body: some View {
        VStack(spacing: 70) {
            //Text("Select an Opera:").fadingText()
            if viewModel.chosenComposer == 0 { //Verdi
                
            } else { //Puccini
                HStack(spacing: 60) {
                    NavigationLink(destination: PickOperaView(chosenOpera: "La Boheme")) {
                        OperaFrame(name: "La Boheme", year: "1896", imageName: "La Boheme")
                    }
                    NavigationLink(destination: PickOperaView(chosenOpera: "Turandot")) {
                        OperaFrame(name: "Turandot", year: "1926", imageName: "Turandot")
                    }
                }
                .buttonStyle(.borderless)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Select an Opera")
                    .font(.headline)
            }
        }
    }
    
    struct OperaFrame: View {
        var name: String
        var year: String
        var imageName: String
        
        @State private var isHovered = false
        @State private var opacity = 0.0
        
        var body: some View {
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 210)
                    .cornerRadius(5)
                    .clipped()
                    .scaleEffect(isHovered ? 1.25 : 1)
                VStack {
                    Text(name)
                        .font(.title3)
                    Text(year)
                        .font(.subheadline)
                }
                .fontDesign(.serif)
                .offset(y: isHovered ? 25: 0)
            }
            .animation(.spring(duration: 1), value: isHovered)
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
}
