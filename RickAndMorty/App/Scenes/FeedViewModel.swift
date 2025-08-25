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
    func searchBarTextDidChange(searchText: String)
    func currentCharacters() -> [Char]
    func fetchCharacters()
}

class FeedViewModel: FeedViewModelProtocol {
    
    private var chars: [Char] = []
    private var filteredChars: [Char] = []
    
    @Published private var state: FeedViewControllerStates = .loading
    
    var statePublisher: AnyPublisher<FeedViewControllerStates, Never> {
        $state.eraseToAnyPublisher()
    }
    
    let service: ServiceProtocol
    
    init(service: ServiceProtocol = Service()) {
        self.service = service
    }
    
    func numberOfItems() -> Int {
        return filteredChars.count
    }
    
    func cellForItem(at indexPath: IndexPath) -> Char {
        return filteredChars[indexPath.item]
    }
    
    func searchBarTextDidChange(searchText: String) {
        if searchText.isEmpty {
            filteredChars = chars
        } else {
            filteredChars = chars.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                translateStatus($0.status).contains(searchText.lowercased())
            }
        }
    }
    
    func currentCharacters() -> [Char] {
        return filteredChars
    }
    
    func fetchCharacters() {
        Task { @MainActor in
            do {
                chars = try await service.getCharacters()
                filteredChars = chars
                state = .loaded
            } catch {
                state = .error
                throw error
            }
        }
    }
    
    private func translateStatus(_ englishStatus: String) -> String {
        switch englishStatus.lowercased() {
        case "alive": return "vivo"
        case "dead": return "morto"
        case "unknown": return "desconhecido"
        default: return englishStatus.lowercased()
        }
    }
}
