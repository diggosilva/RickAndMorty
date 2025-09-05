//
//  LocationViewModel.swift
//  RickAndMorty
//
//  Created by Diggo Silva on 04/09/25.
//

import Foundation
import Combine

enum LocationViewControllerStates {
    case loading
    case loaded
    case error
}

protocol LocationViewModelProtocol: StatefulViewModel where State == LocationViewControllerStates {
    func numberOfRows() -> Int
    func location(at indexPath: IndexPath) -> Location
    func fetchLocations()
}

class LocationViewModel {
    
    private var locations: [Location] = []
    private var page: Int = 1
    private var isLoading: Bool = false
    private var hasMorePages: Bool = true
    
    @Published private var state: LocationViewControllerStates = .loading
    
    var statePublisher: AnyPublisher<LocationViewControllerStates, Never> {
        $state.eraseToAnyPublisher()
    }
    
    private let service: ServiceProtocol
    
    init(service: ServiceProtocol = Service()) {
        self.service = service
    }
    
    func numberOfRows() -> Int {
        return locations.count
    }
    
    func location(at indexPath: IndexPath) -> Location {
        return locations[indexPath.row]
    }
    
    func fetchLocations() {
        guard !isLoading, hasMorePages else { return }
        
        isLoading = true
        
        Task { @MainActor in
            do {
                let newLocations = try await service.getLocations(page: page)
                locations.append(contentsOf: newLocations.locations)
                state = .loaded
                page += 1
                hasMorePages = newLocations.hasMorePages
            } catch {
                state = .error
            }
            isLoading = false
        }
    }
}
