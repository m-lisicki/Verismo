//
//  PickAndLoadView.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 26/12/2024.
//

import SwiftUI

struct PickOpera: View {
    @ObservedObject var viewModel: OperaViewModel
    
    @State var operaName: String?
    
    var filteredOperas: [LibrettoDatabase.Libretto] {
        if let operaName = operaName, !operaName.isEmpty {
            return viewModel.operas.filter { $0.operaTitle.contains(operaName) }
        } else {
            return viewModel.operas
        }
    }
    
    var body: some View {
        VStack {
            Text("Choose Your Edition from our catalouge:")
                .fadingText()
            
            List(filteredOperas) { opera in
                Button(action: { viewModel.selectOpera(opera) }) {
                    OperaRow(opera: opera).padding(.vertical, 8)
                }
                #if os(macOS)
                .buttonStyle(.borderless)
                #endif
            }
            #if os(macOS)
            .listStyle(.plain)
            #else
            .listStyle(.inset)
            #endif
            .cornerRadius(10)
        }
        .padding()
    }
}

#if os(macOS)
struct OperaRow: View {
    let opera: LibrettoDatabase.Libretto
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            
            Image(opera.thumbnailImageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 85)
                .cornerRadius(8)
                .clipped()
            
            
            VStack(alignment: .leading, spacing: 5) {
                Text(opera.operaTitle)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .fontDesign(.serif)
                
                HStack {
                    Text("Conductor: \(opera.conductor)")
                    Spacer()
                    Text("Orchestra: \(opera.orchestra)")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                HStack {
                    Text("Year: \(opera.year)")
                    Spacer()
                    Text("Translation: \(opera.translationLanguage)")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        }
    }
}
#else
struct OperaRow: View {
    let opera: LibrettoDatabase.Libretto
    
    var body: some View {
            HStack(alignment: .top, spacing: 15) {
                
                Image(opera.thumbnailImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 85)
                    .cornerRadius(8)
                    .clipped()
                
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(opera.operaTitle)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .fontDesign(.serif)
                    
                    Group {
                        Text("Conductor: \(opera.conductor)")
                        Text("Year: \(opera.year)")
                        Text("Translation: \(opera.translationLanguage)")
                        /*Text("Orchestra: \(opera.orchestra)")
                         .font(.subheadline)
                         .foregroundColor(.secondary)*/
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
            }
    }
}
#endif

struct PickAndLoadAudio: View {
    @State var isPresented = false
    let prepareAudioPlayer: (URL) -> Void
    
    var body: some View {
        Button(action: {
            isPresented = true
        }) {
            VStack(spacing: 13) {
                Image(systemName: "folder.badge.plus")
                    .font(.system(size: 23))
                    .symbolRenderingMode(.hierarchical)
                Text("Load Audio from Disk")
                    .font(.footnote)
            }
            .frame(height: 55)
            .fontWeight(.light)
            .padding()
        }
        .buttonStyle(.borderless)
        .background(.ultraThickMaterial)
        .cornerRadius(5)
        .fileImporter(
            isPresented: $isPresented,
            allowedContentTypes: [.audio],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedFile = try result.get().first else { return }
                _ = selectedFile.startAccessingSecurityScopedResource()
                defer { selectedFile.stopAccessingSecurityScopedResource() }
                
                prepareAudioPlayer(selectedFile)
            } catch {
                print("Failed to load the audio file: \(error.localizedDescription)")
            }
        }
    }
}
