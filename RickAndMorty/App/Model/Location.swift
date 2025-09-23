//
//  Location.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 19/08/25.
//

import Foundation

struct Location: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
    
    func residentsIDs() -> [Int] {
        var ids: [Int] = []
        
        for resident in residents {
            ids.append(Int(resident.split(separator: "/").last ?? "") ?? 0)
        }
        return ids
    }
}

struct LocationChar {
    let location: Location
    let chars: [Char]
}
