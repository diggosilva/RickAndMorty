//
//  Char.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 17/08/25.
//

import Foundation

struct Char: Codable {
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
}

struct CharLocation: Codable {
    let name: String
    let url: String
}
