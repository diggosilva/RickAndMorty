//
//  Service.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 17/08/25.
//

import Foundation

final class Service {
    
    func getCharacters() async throws -> [Char] {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("DEBUG: Statucode.. \(httpResponse.statusCode)")
        }
        
        let charResponse = try JSONDecoder().decode(CharResponse.self, from: data)
        
        let characters = charResponse.results.map { chars in
            Char(
                id: chars.id,
                name: chars.name,
                status: chars.status,
                species: chars.species,
                type: chars.type,
                gender: chars.gender,
                origin: Location(name: chars.origin.name, url: chars.origin.url),
                location: Location(name: chars.location.name, url: chars.location.url),
                image: chars.image,
                episode: chars.episode,
                url: chars.url,
                created: chars.created
            )
        }
        return characters
    }
}
