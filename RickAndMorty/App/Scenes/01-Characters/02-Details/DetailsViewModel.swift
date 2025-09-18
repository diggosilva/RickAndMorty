//
//  DetailsViewModel.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 27/08/25.
//

import Foundation
import Combine

enum DetailsViewControllerStates {
    case loading
    case loaded
    case error
}

protocol DetailsViewModelProtocol: StatefulViewModel where State == DetailsViewControllerStates {
    func numberOfInfoItems() -> Int
    func infoItem(at indexPath: IndexPath) -> (title: String, value: String)
    func numberOfRows() -> Int
    func cellForRow(at indexPath: IndexPath) -> Episode
    func fetchEpisodes()
    
    var imageURL: String { get }
    var name: String { get }
}

class DetailsViewModel: DetailsViewModelProtocol {
    
    private let char: Char
    private let service: ServiceProtocol
    
    @Published private var state: DetailsViewControllerStates = .loading
    
    var statePublisher: AnyPublisher<DetailsViewControllerStates, Never> {
        $state.eraseToAnyPublisher()
    }
    
    init(char: Char, service: ServiceProtocol = Service()) {
        self.char = char
        self.service = service
    }
    
    var name: String { return char.name }
    var status: String { return char.status }
    var gender: String { return char.gender }
    var origin: String { return char.origin.name }
    var species: String { return char.species }
    var imageURL: String { return char.image }
    
    // MARK: - CollectionView (info items)
    
    private var infoItems: [(title: String, value: String)] {
        return [("Status", status), ("Espécie", species), ("Gênero", gender), ("Origem", origin)]
    }

    func numberOfInfoItems() -> Int {
        return infoItems.count
    }

    func infoItem(at indexPath: IndexPath) -> (title: String, value: String) {
        return infoItems[indexPath.item]
    }
    
    // MARK: - TableView (episódios)
    
    var episodes: [Episode] = []
    
    func numberOfRows() -> Int {
        return episodes.count
    }
    
    func cellForRow(at indexPath: IndexPath) -> Episode {
        return episodes[indexPath.row]
    }
    
    func fetchEpisodes() {
        state = .loading
        
        Task{ @MainActor in
            do {
                let episode = try await service.getMultipleEpisodes(ids: char.episodeIDs())
                episodes.append(contentsOf: episode)
                state = .loaded
            } catch {
                state = .error
            }
        }
    }
}
