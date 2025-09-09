//
//  Service.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 17/08/25.
//

import Foundation

protocol ServiceProtocol {
    func getCharacterDetail(id: Int) async throws -> Char
    func getCharacters(page: Int) async throws -> CharsPage
    func getLocations(page: Int) async throws -> LocationsPage
    func getEpisodes(page: Int) async throws -> EpisodesPage
}

final class Service: ServiceProtocol {
    
    func getCharacterDetail(id: Int) async throws -> Char {
        let charResponse = try await request(endpoint: Endpoint.characterDetail(id: id), type: CharResponse.ResultChar.self)
        return Char(
            id: charResponse.id,
            name: charResponse.name,
            status: charResponse.status,
            species: charResponse.species,
            type: charResponse.type,
            gender: charResponse.gender,
            origin: CharLocation(name: charResponse.origin.name, url: charResponse.origin.url),
            location: CharLocation(name: charResponse.location.name, url: charResponse.location.url),
            image: charResponse.image,
            episode: charResponse.episode,
            url: charResponse.url,
            created: charResponse.created
        )
    }
    
    func getCharacters(page: Int) async throws -> CharsPage {
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
        return CharsPage(characters: characters, hasMorePages: charResponse.info.next != nil)
    }
    
    func getLocations(page: Int) async throws -> LocationsPage {
        let locationResponse = try await request(endpoint: Endpoint.pagedLocations(page: page), type: LocationResponse.self)
        
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
        return LocationsPage(locations: locations, hasMorePages: locationResponse.info.next != nil)
    }
    
    func getEpisodes(page: Int) async throws -> EpisodesPage {
        let episodeResponse = try await request(endpoint: Endpoint.pagedEpisodes(page: page), type: EpisodeResponse.self)
        
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
        return EpisodesPage(episodes: episodes, hasMorePages: episodeResponse.info.next != nil)
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
