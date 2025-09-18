//
//  Service.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 17/08/25.
//

import Foundation

protocol ServiceProtocol {
    func getMultipleCharacters(ids: [Int]) async throws -> [Char]
    func getCharacters(page: Int) async throws -> CharsPage
    func getLocations(page: Int) async throws -> LocationsPage
    func getMultipleEpisodes(ids: [Int]) async throws -> [Episode]
    func getEpisodes(page: Int) async throws -> EpisodesPage
}

final class Service: ServiceProtocol {
    
    func getMultipleCharacters(ids: [Int]) async throws -> [Char] {
        let charResponse = try await request(endpoint: Endpoint.multipleCharacters(ids: ids), type: [CharResponse.ResultChar].self)

        let characters = charResponse.map { chars in
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
                episodes: chars.episode,
                url: chars.url,
                created: chars.created
            )
        }
        return characters
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
                episodes: chars.episode,
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
    
    func getMultipleEpisodes(ids: [Int]) async -> [Episode] {
        do {
            if ids.count == 1 {
                let episodeResponse = try await request(endpoint: Endpoint.multipleEpisodes(ids: ids), type: EpisodeResponse.ResultEpisode.self)
                
                let episode = Episode(
                    id: episodeResponse.id,
                    name: episodeResponse.name,
                    airDate: episodeResponse.airDate,
                    episode: episodeResponse.episode,
                    characters: episodeResponse.characters,
                    url: episodeResponse.url,
                    created: episodeResponse.created
                )
                return [episode]
            } else {
                let episodeResponse = try await request(endpoint: Endpoint.multipleEpisodes(ids: ids), type: [EpisodeResponse.ResultEpisode].self)
                
                let episodes = episodeResponse.map { episode in
                    Episode(
                        id: episode.id,
                        name: episode.name,
                        airDate: episode.airDate,
                        episode: episode.episode,
                        characters: episode.characters,
                        url: episode.url,
                        created: episode.created
                    )
                }
                return episodes
            }
        } catch {
            print("Erro ao buscar episódios: \(error.localizedDescription)")
            return []
        }
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
