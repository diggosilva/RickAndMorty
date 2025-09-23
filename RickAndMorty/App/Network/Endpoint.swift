//
//  Endpoint.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 19/08/25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol EndpointProtocol {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    
    func createURL() -> URL?
}

enum Endpoint: EndpointProtocol {
    case character
    case episode
    case location
    case characterDetail(id: Int)
    case episodeDetail(id: Int)
    case locationDetail(id: Int)
    case pagedCharacters(page: Int)
    case pagedEpisodes(page: Int)
    case pagedLocations(page: Int)
    case multipleCharacters(ids: [Int])
    case multipleEpisodes(ids: [Int])
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "rickandmortyapi.com"
    }
    
    var path: String {
        switch self {
        case .character: return "/api/character"
        case .episode: return "/api/episode"
        case .location: return "/api/location"
        case .characterDetail(let id): return "/api/character/\(id)"
        case .episodeDetail(let id): return "/api/episode/\(id)"
        case .locationDetail(let id): return "/api/location/\(id)"
        case .pagedCharacters: return "/api/character"
        case .pagedEpisodes: return "/api/episode"
        case .pagedLocations: return "/api/location"
        case .multipleCharacters(ids: let ids):
            let idsString = ids.map(String.init).joined(separator: ",")
            return "/api/character/\(idsString)"
        
        case .multipleEpisodes(ids: let ids):
            let idsString = ids.map(String.init).joined(separator: ",")
            return "/api/episode/\(idsString)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .pagedCharacters(let page),
                .pagedEpisodes(let page), 
                .pagedLocations(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
            
        default: return nil
        }
    }
    
    func createURL() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        
//        print("DEBUG: URL.. \(String(describing: urlComponents.url))")
        return urlComponents.url
    }
}
