//
//  ComposersMapView.swift
//  Verismo
//
//  Created by Michał Lisicki on 17/01/2025.
//

import SwiftUI
import MapKit


struct ComposersMapView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            Map(selection: $viewModel.chosenComposer) {
                ForEach(viewModel.composers.indices, id: \.self) { index in
                    Annotation(viewModel.composers[index].name, coordinate: viewModel.composers[index].coordinate) {
                        NavigationLink(destination: ComposerInfoView()) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(borderColor(for: viewModel.composers[index].birthYear))
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.secondary, lineWidth: 5)
                                Image(viewModel.composers[index].imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: 50, maxHeight: 80)
                                    .cornerRadius(5)
                                    .padding(5)
                            }
                        }
                        .buttonStyle(.borderless)
                    }
                    .tag(index)
                }
            }
            .mapStyle(.standard(elevation: .realistic))
        }
        .toolbar {
            // ToolbarItem(placement: .principal) {
            Text("Composers Map")
            // .font(.headline)
            //}
        }
        
    }
    
    
    private func borderColor(for year: Int) -> Color {
        switch year {
        case ..<1800:
            return .blue
        case 1800..<1850:
            return .green
        case 1850...:
            return .orange
        default:
            return .gray
        }
    }
}
