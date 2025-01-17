//
//  ComposerInfoView.swift
//  Verismo
//
//  Created by Michał Lisicki on 17/01/2025.
//
import SwiftUI

struct ComposerInfoView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Composer Image
                HStack {
                    Image(viewModel.composers[viewModel.chosenComposer ?? 0].imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 10)
                        .padding(.horizontal)
                    
                    // Composer Name
                    Text(viewModel.composers[viewModel.chosenComposer ?? 0].name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // Biography
                Text(viewModel.composers[viewModel.chosenComposer ?? 0].name)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                
                // Navigation to Operas View
                NavigationLink(destination: OperasView()){
                    HStack(spacing: 13) {
                        Image(systemName: "book.pages")
                            .font(.system(size: 23))
                            .symbolRenderingMode(.hierarchical)
                        Text("Explore \(viewModel.composers[viewModel.chosenComposer ?? 0].name) Operas")
                            .font(.headline)
                    }
                    .fontWeight(.light)
                    .frame(width: 175, height: 55)
                    .padding()
                }
                .buttonStyle(.borderless)
                .background(.ultraThickMaterial)
                .cornerRadius(5)
            }
            .padding(.vertical)
        }
        //.navigationTitle(viewModel.composers[viewModel.chosenComposer ?? 0].name)
    }
}

#Preview {
    ComposerInfoView()
}
