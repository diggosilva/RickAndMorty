//
//  Char.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 17/08/25.
//

import Foundation

struct Char: Codable, Hashable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: CharLocation
    let location: CharLocation
    let image: String
    let episodes: [String]
    let url: String
    let created: String
    
    static func == (lhs: Char, rhs: Char) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.status == rhs.status &&
        lhs.species == rhs.species &&
        lhs.type == rhs.type &&
        lhs.gender == rhs.gender &&
        lhs.origin == rhs.origin &&
        lhs.location == rhs.location &&
        lhs.image == rhs.image &&
        lhs.episodes == rhs.episodes &&
        lhs.url == rhs.url &&
        lhs.created == rhs.created
    }
    
    func episodeIDs() -> [Int] {
        var ids: [Int] = []
        
        for episode in episodes {
            ids.append(Int(episode.split(separator: "/").last ?? "") ?? 0)
        }
        return ids
    }
    
    func getStatusChar() -> String {
        if status == "Dead" {
            return "🔴 Dead"
        } else if status == "Alive" {
            return "🟢 Alive"
        }
        return "🟡 Unknown"
    }
}

struct CharLocation: Codable, Equatable, Hashable {
    let name: String
    let url: String
}
