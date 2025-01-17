//
//  Model.swift
//  Verismo
//
//  Created by Michał Lisicki on 25/12/2024.
//

import Foundation
import MapKit

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
        let performer: String
        let orchestra: String
        let thumbnailImageName: String
        let audioName: String
        let lyrics: [LibrettoText]
        let sourceUrl: String
    }
    let operas: [Libretto]
}


struct Composer {
    let name: String
    let birthPlace: String
    let coordinate: CLLocationCoordinate2D
    let imageName: String
    let birthYear: Int
    let lifespan: String
}
