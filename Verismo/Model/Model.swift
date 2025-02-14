//
//  Model.swift
//  Verismo
//
//  Created by Michał Lisicki on 21/01/2025.
//

import CoreLocation.CLLocation

struct Composer: Identifiable {
    let id = UUID()
    let composerID: ComposerID
    let firstname: String
    let surname: String
    let birthPlace: String
    let birthCoordinates: CLLocationCoordinate2D
    let lifespan: String
    let biography: String
}

struct Opera: Identifiable {
    let id = UUID()
    let operaID: OperaID
    let composerID: ComposerID
    let title: String
    let coverImageName: String
    let premiereDate: Date
    let background: String
    let synopsis: String
    let musicInsights: String
}

struct Aria {
    let ariaID: AriaID
    let operaID: OperaID
    let title: String
    let imageName: String
    let mainCharacter: String
    let background: String
    let recordingID: Int?
}

struct Recording: Identifiable, Decodable {
    let id: Int
    let ariaID: Int
    let conductor: String
    let singer: String
    let orchestra: String
    let year: String
    let subtitlesLanguage: String
    let audioPath: String
    let imageName: String
    let license: String
    let originalAttribution: String?
    let url: String
    let lyrics: [Lyric]
}

struct Lyric: Decodable {
    let start: TimeInterval
    let end: TimeInterval
    let text: String
    let singer: String
    let translation: String?
}
