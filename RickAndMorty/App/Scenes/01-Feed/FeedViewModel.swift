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
    func character(at indexPath: IndexPath) -> Char
    func searchBarTextDidChange(searchText: String)
    func currentCharacters() -> [Char]
    func fetchCharacters()
}

class FeedViewModel: FeedViewModelProtocol {
    
    private var chars: [Char] = []
    private var filteredChars: [Char] = []
    private var page: Int = 1
    private var isLoading: Bool = false
    private var searchText: String = ""
    
    private var isFiltering: Bool {
        !searchText.isEmpty
    }
    
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
    
    func character(at indexPath: IndexPath) -> Char {
        return filteredChars[indexPath.item]
    }
    
    func searchBarTextDidChange(searchText: String) {
        self.searchText = searchText
        
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
        guard !isLoading && !isFiltering else { return }
        
        isLoading = true
        
        Task { @MainActor in
            do {
                let newChars = try await service.getCharacters(page: page)
                chars += newChars
                filteredChars = chars
                state = .loaded
                page += 1
            } catch {
                state = .error
                throw error
            }
            isLoading = false
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
