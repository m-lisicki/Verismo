//
//  Model.swift
//  Opera Lyrics
//
//  Created by Michał Lisicki on 25/12/2024.
//

import Foundation

struct LibrettoDatabase: Codable {
    struct Libretto: Codable, Identifiable {
        struct LibrettoText: Codable {
            let startTime: TimeInterval
            let endTime: TimeInterval
            let text: String
            let singer: String
            let translation: String?
        }
        let id: Int
        let composer: String
        let operaTitle: String
        let translationLanguage: String
        let conductor: String
        let year: String
        let orchestra: String
        let thumbnailImageName: String
        let lyrics: [LibrettoText]
    }
    let operas: [Libretto]
}
