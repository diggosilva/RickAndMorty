//
//  EpisodesViewModel.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 02/09/25.
//

import Foundation
import Combine

enum EpisodesViewControllerStates {
    case loading
    case loaded
    case error
}

protocol EpisodeViewModel: StatefulViewModel where State == EpisodesViewControllerStates {
    func numberOfRows() -> Int
    func episode(at indexPath: IndexPath) -> Episode
    func fetchEpisodes()
}

class EpisodesViewModel: EpisodeViewModel {
    
    private var episodes: [Episode] = []
    private let service: ServiceProtocol
    @Published private var state: EpisodesViewControllerStates = .loading
    
    var statePublisher: AnyPublisher<EpisodesViewControllerStates, Never> {
        $state.eraseToAnyPublisher()
    }
    
    init(service: ServiceProtocol = Service()) {
        self.service = service
    }
    
    func numberOfRows() -> Int {
        return episodes.count
    }
    
    func episode(at indexPath: IndexPath) -> Episode {
        return episodes[indexPath.row]
    }
    
    func fetchEpisodes() {
        state = .loading
        
        Task {
            do {
                let episodes = try await service.getEpisodes()
                self.episodes = episodes
                state = .loaded
            } catch {
                state = .error
                throw error
            }
        }
    }
}
