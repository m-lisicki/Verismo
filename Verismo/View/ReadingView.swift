//
//  ReadingView.swift
//  Verismo
//
//  Created by Michał Lisicki on 17/01/2025.
//
import SwiftUI

struct ReadingView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
            ZStack {
                BackgroundGradient()
                ScrollView {
                    VStack(spacing: 20) {
                        Text("La Bohème")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.top)
                        
                        Text("An opera in four acts by Giacomo Puccini.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Divider()
                        
                        ForEach(operaActs, id: \.title) { act in
                            VStack(alignment: .leading) {
                                Text(act.title)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .padding(.bottom, 5)
                                
                                Text(act.content)
                                    .padding()
                                    .frame(width: 300, height: 70)
                                    .background(colorScheme == .light ? Color.white : Color.black)
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)

                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding()
                }
            }
            //.navigationTitle("Opera Reading")
        }
}

struct Act {
    let title: String
    let content: String
}

let operaActs = [
    Act(title: "Act 1", content: "In a Parisian garret, the poet Rodolfo and his friends..."),
    Act(title: "Act 2", content: "The scene shifts to the Latin Quarter of Paris..."),
    Act(title: "Act 3", content: "In the third act, the characters face the realities of life..."),
    Act(title: "Act 4", content: "The final act takes place in the garret once again...")
]

#Preview {
    ReadingView()
}
