//
//  MockService.swift
//  RickAndMortyTests
//
//  Created by Diggo Silva on 27/09/25.
//

import XCTest
import Combine
@testable import RickAndMorty

class MockService: ServiceProtocol {
    
    var isSuccess: Bool = true
    var shouldReturnEmpty: Bool = false
    var shouldReturnMatchingResidents = false
    
    func getCharacters(page: Int) async throws -> CharsPage {
        if isSuccess {
            let characters = shouldReturnEmpty ? [] : [
                Char(id: 1, name: "Rick Sanchez", status: "Alive", species: "", type: "", gender: "", origin: CharLocation(name: "", url: ""), location: CharLocation(name: "", url: ""), image: "", episodes: [], url: "", created: ""),
                Char(id: 2, name: "Morty Smith", status: "Alive", species: "", type: "", gender: "", origin: CharLocation(name: "", url: ""), location: CharLocation(name: "", url: ""), image: "", episodes: [], url: "", created: "")
            ]
             return CharsPage(characters: characters, hasMorePages: !shouldReturnEmpty)
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    func getMultipleEpisodes(ids: [Int]) async throws -> [Episode] {
        if isSuccess {
            let episodes: [Episode] = [
                Episode(id: 1, name: "Pilot", airDate: "", episode: "", characters: [], url: "", created: ""),
                Episode(id: 2, name: "CoPilot", airDate: "", episode: "", characters: [], url: "", created: "")
            ]
            return episodes
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    func getLocations(page: Int) async throws -> LocationsPage {
        if isSuccess {
            let locations: [Location]

            if shouldReturnEmpty {
                locations = []
            } else if shouldReturnMatchingResidents {
                locations = [
                    Location(id: 1, name: "Earth", type: "Planet", dimension: "", residents: ["https://rickandmortyapi.com/api/character/1"], url: "", created: "")
                ]
            } else {
                locations = [
                    Location(id: 1, name: "Earth", type: "Planet", dimension: "", residents: [], url: "", created: ""),
                    Location(id: 2, name: "Mars", type: "Planet", dimension: "", residents: [], url: "", created: "")
                ]
            }
            return LocationsPage(locations: locations, hasMorePages: !shouldReturnEmpty)
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    func getMultipleCharacters(ids: [Int]) async throws -> [Char] {
        if isSuccess {
            let chars: [Char] = [
                Char(id: 1, name: "Rick Sanchez", status: "Alive", species: "", type: "", gender: "", origin: CharLocation(name: "", url: ""), location: CharLocation(name: "", url: ""), image: "", episodes: [], url: "", created: ""),
                Char(id: 2, name: "Morty Smith", status: "Alive", species: "", type: "", gender: "", origin: CharLocation(name: "", url: ""), location: CharLocation(name: "", url: ""), image: "", episodes: [], url: "", created: "")
            ]
            return chars
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    func getEpisodes(page: Int) async throws -> EpisodesPage {
        if isSuccess {
            let episodes: [Episode] = [
                Episode(id: 1, name: "Pilot", airDate: "", episode: "", characters: [], url: "", created: ""),
                Episode(id: 2, name: "CoPilot", airDate: "", episode: "", characters: [], url: "", created: "")
            ]
             return EpisodesPage(episodes: episodes, hasMorePages: !shouldReturnEmpty)
        } else {
            throw URLError(.badServerResponse)
        }
    }
}
