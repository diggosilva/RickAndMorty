//
//  Episode.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 20/08/25.
//

import Foundation

struct Episode: Codable {
    let id: Int
    let name, airDate, episode: String
    let characters: [String]
    let url: String
    let created: String
}
