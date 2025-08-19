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
    var baseURL: String { get }
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
    
    var baseURL: String {
        return "https://rickandmortyapi.com"
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
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .pagedCharacters(let page): return [URLQueryItem(name: "page", value: "\(page)")]
            
        default: return nil
        }
    }
    
    func createURL() -> URL? {
        var urlComponets = URLComponents(string: baseURL)
        urlComponets?.path = path
        urlComponets?.queryItems = queryItems
        
        print("DEBUG: URL.. \(String(describing: urlComponets?.url))")
        return urlComponets?.url
    }
}
