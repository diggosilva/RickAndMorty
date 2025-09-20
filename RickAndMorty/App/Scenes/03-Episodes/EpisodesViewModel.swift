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

protocol EpisodeViewModelProtocol: StatefulViewModel where State == EpisodesViewControllerStates {
    func numberOfRows() -> Int
    func episode(at indexPath: IndexPath) -> Episode
    func fetchEpisodes()
}

class EpisodesViewModel: EpisodeViewModelProtocol {
    
    private var episodes: [Episode] = []
    private let service: ServiceProtocol
    private var page: Int = 1
    private var isLoading: Bool = false
    private var hasMorePages: Bool = true
    
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
        guard !isLoading, hasMorePages else { return }
        
        isLoading = true
        
        Task { @MainActor in
            do {
                let newEpisodes = try await service.getEpisodes(page: page)
                episodes.append(contentsOf: newEpisodes.episodes)
                state = .loaded
                page += 1
                hasMorePages = newEpisodes.hasMorePages
            } catch {
                state = .error
            }
            isLoading = false
        }
    }
}
