//
//  DetailsViewModel.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 27/08/25.
//

import Foundation

protocol DetailsViewModelProtocol {
    func numberOfRows() -> Int
    func cellForRow(at indexPath: IndexPath) -> Int
}

class DetailsViewModel: DetailsViewModelProtocol {
    
    private let char: Char
    
    init(char: Char) {
        self.char = char
    }
    
    var name: String { return char.name }
    var status: String { return char.status }
    var gender: String { return char.gender }
    var origin: String { return char.origin.name }
    var species: String { return char.species }
    var imageURL: String { return char.image }
    
    var episodes: [Int] {
        char.episode.compactMap { urlString in
            return Int(urlString.split(separator: "/").last ?? "")
        }
    }
    
    func numberOfRows() -> Int {
        return episodes.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> Int {
        return episodes[indexPath.row]
    }
}
