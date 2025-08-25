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
    let episode: [String]
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
        lhs.episode == rhs.episode &&
        lhs.url == rhs.url &&
        lhs.created == rhs.created
    }
}

struct CharLocation: Codable, Equatable, Hashable {
    let name: String
    let url: String
}
