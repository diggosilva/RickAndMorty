//
//  Service.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 17/08/25.
//

import Foundation

protocol ServiceProtocol {
    func getCharacters(page: Int) async throws -> [Char]
    func getLocations() async throws -> [Location]
    func getEpisodes() async throws -> [Episode]
}

final class Service: ServiceProtocol {
    
    func getCharacters(page: Int) async throws -> [Char] {
        let charResponse = try await request(endpoint: Endpoint.pagedCharacters(page: page), type: CharResponse.self)
        
        let characters = charResponse.results.map { chars in
            Char(
                id: chars.id,
                name: chars.name,
                status: chars.status,
                species: chars.species,
                type: chars.type,
                gender: chars.gender,
                origin: CharLocation(name: chars.origin.name, url: chars.origin.url),
                location: CharLocation(name: chars.location.name, url: chars.location.url),
                image: chars.image,
                episode: chars.episode,
                url: chars.url,
                created: chars.created
            )
        }
        return characters
    }
    
    func getLocations() async throws -> [Location] {
        let locationResponse = try await request(endpoint: Endpoint.location, type: LocationResponse.self)
        
        let locations = locationResponse.results.map { locations in
            Location(
                id: locations.id,
                name: locations.name,
                type: locations.type,
                dimension: locations.dimension,
                residents: locations.residents,
                url: locations.url,
                created: locations.created
            )
        }
        return locations
    }
    
    func getEpisodes() async throws -> [Episode] {
        let episodeResponse = try await request(endpoint: Endpoint.episode, type: EpisodeResponse.self)
        
        let episodes = episodeResponse.results.map { episodes in
            Episode(
                id: episodes.id,
                name: episodes.name,
                airDate: episodes.airDate,
                episode: episodes.episode,
                characters: episodes.characters,
                url: episodes.url,
                created: episodes.created
            )
        }
        return episodes
    }
    
    private func request<T: Codable>(endpoint: EndpointProtocol, type: T.Type) async throws -> T {
        guard let url = endpoint.createURL() else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("DEBUG: Statuscode.. \(httpResponse.statusCode)")
        }
        
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
}
