//
//  Movie.swift
//  TestTaskVoio
//
//  Created by Anton on 29.03.2023.
//

import Foundation

struct Movie: Codable {
    let trackName: String
    let artworkUrl100: String
    let releaseDate: String
    let primaryGenreName: String
    let longDescription: String
    let trackViewUrl: String

    enum CodingKeys: String, CodingKey {
        case trackName, artworkUrl100, releaseDate, primaryGenreName, longDescription, trackViewUrl
    }
}
