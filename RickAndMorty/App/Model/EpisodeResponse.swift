//
//  EpisodeResponse.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 20/08/25.
//

import Foundation

struct EpisodeResponse: Codable {
    let info: Info
    let results: [ResultEpisode]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    struct ResultEpisode: Codable {
        let id: Int
        let name, airDate, episode: String
        let characters: [String]
        let url: String
        let created: String

        enum CodingKeys: String, CodingKey {
            case id, name
            case airDate = "air_date"
            case episode, characters, url, created
        }
    }
}
