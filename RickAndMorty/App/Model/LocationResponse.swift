//
//  LocationResponse.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 19/08/25.
//

import Foundation

struct LocationResponse: Codable {
    let info: Info
    let results: [ResultLocation]

    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    struct ResultLocation: Codable {
        let id: Int
        let name: String
        let type: String
        let dimension: String
        let residents: [String]
        let url: String
        let created: String
    }
}
