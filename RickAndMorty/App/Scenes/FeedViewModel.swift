//
//  FeedViewModel.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 21/08/25.
//

import Foundation
import Combine

enum FeedViewControllerStates {
    case loading
    case loaded
    case error
}

protocol FeedViewModelProtocol: StatefulViewModel where State == FeedViewControllerStates {
    func numberOfItems() -> Int
    func cellForItem(at indexPath: IndexPath) -> Char
    func fetchCharacters()    
}

class FeedViewModel: FeedViewModelProtocol {
    
    var chars: [Char] = []
    
    @Published private var state: FeedViewControllerStates = .loading
    
    var statePublisher: AnyPublisher<FeedViewControllerStates, Never> {
        $state.eraseToAnyPublisher()
    }
    
    let service: ServiceProtocol
    
    init(service: ServiceProtocol = Service()) {
        self.service = service
    }
    
    func numberOfItems() -> Int {
        return chars.count
    }
    
    func cellForItem(at indexPath: IndexPath) -> Char {
        return chars[indexPath.item]
    }
    
    func fetchCharacters() {
        Task { @MainActor in
            do {
                chars = try await service.getCharacters()
                state = .loaded
            } catch {
                state = .error
                throw error
            }
        }
    }
}
