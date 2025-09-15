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
    func location(at indexPath: IndexPath) -> Planet
    func fetchLocations()
}

class LocationViewModel {
    
    private var locations: [Planet] = []
    private var page: Int = 1
    private var isLoading: Bool = false
    private var hasMorePages: Bool = true
    private var residentsByLocation: [Int : [Resident]] = [:]
    
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
    
    func location(at indexPath: IndexPath) -> Planet {
        return locations[indexPath.row]
    }
    
    func fetchLocations() {
        guard !isLoading, hasMorePages else { return }
        
        isLoading = true
        
        Task { @MainActor in
            do {
                let newLocations = try await service.getLocations(page: page)
                locations.append(contentsOf: newLocations.locations)
                
                var ids: [Int] = []
                
                for location in newLocations.locations {
                    ids.append(contentsOf: location.residentsIDs())
                }
                
                let residents = try await service.getMultipleCharacters(ids: ids)
                
                print(residents)
                
                
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
