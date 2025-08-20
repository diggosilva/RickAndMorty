//
//  CharResponse.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 17/08/25.
//

import Foundation

struct CharResponse: Codable {
    let info: Info
    let results: [CharDTO]

    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    struct CharDTO: Codable {
        let id: Int
        let name: String
        let status: String
        let species: String
        let type: String
        let gender: String
        let origin: LocationDTO
        let location: LocationDTO
        let image: String
        let episode: [String]
        let url: String
        let created: String
    }

    struct LocationDTO: Codable {
        let name: String
        let url: String
    }
}
