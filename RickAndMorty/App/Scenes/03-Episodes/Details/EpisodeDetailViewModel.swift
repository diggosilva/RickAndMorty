//
//  EpisodeDetailViewModel.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 20/09/25.
//

import Foundation
import Combine

enum EpisodeDetailViewControllerState {
    case loading
    case loaded
    case error
}

protocol EpisodeDetailViewModelProtocol: StatefulViewModel where State == EpisodeDetailViewControllerState {
    func fetchCharactersInEpisode()
    func numberOfRows() -> Int
    func characterInEpisode(at indexPath: IndexPath) -> Char
}

final class EpisodeDetailViewModel: EpisodeDetailViewModelProtocol {
    
    @Published private var state: EpisodeDetailViewControllerState = .loading
    
    var statePublisher: AnyPublisher<EpisodeDetailViewControllerState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    private(set) var characters: [Char] = []
    private let service: ServiceProtocol
    private let episode: Episode
    
    init(service: ServiceProtocol = Service(), episode: Episode) {
        self.service = service
        self.episode = episode
    }
    
    func numberOfRows() -> Int {
        characters.count
    }
    
    func characterInEpisode(at indexPath: IndexPath) -> Char {
        return characters[indexPath.row]
    }
    
    func fetchCharactersInEpisode() {
        Task { @MainActor in
            do {
                let ids = episode.charactersIDs()
                characters = try await service.getMultipleCharacters(ids: ids)
                state = .loaded
            } catch {
                state = .error
            }
        }
    }
}
