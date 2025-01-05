//
//  Operas.swift
//  Verismo
//
//  Created by Michał Lisicki on 29/12/2024.
//

import SwiftUI

struct OperasView: View {
    let chosenComposer: Int?
    @Binding var chosenOpera: String?
    @State var click = false

    
    var body: some View {
        VStack(spacing: 70) {
            Text("Select an Opera:")
                .fadingText()
            if chosenComposer == 0 { //Verdi
                
            } else { //Puccini
                OperaButton(name: "Turandot", year: "1926", imageName: "Turandot") {
                    chosenOpera = "Turandot";
                    click.toggle()
                }
            }
        }
        .sensoryFeedback(.selection, trigger: click)
    }
    
    struct OperaButton: View {
        var name: String
        var year: String
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
}
