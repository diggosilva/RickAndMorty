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
    func location(at indexPath: IndexPath) -> LocationChar
    func fetchLocations()
}

class LocationViewModel {
    
    private var locationsChar: [LocationChar] = []
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
        return locationsChar.count
    }
    
    func location(at indexPath: IndexPath) -> LocationChar {
        return locationsChar[indexPath.row]
    }
    
    func fetchLocations() {
        guard !isLoading, hasMorePages else { return }
        
        isLoading = true
        
        Task { @MainActor in
            do {
                let newLocations = try await service.getLocations(page: page)
                var ids: [Int] = []
                
                for location in newLocations.locations {
                    ids.append(contentsOf: location.residentsIDs())
                }
                
                let residents = try await service.getMultipleCharacters(ids: ids)
                
                for location in newLocations.locations {
                    var chars: [Char] = []
                    
                    for resident in residents {
                        if location.residentsIDs().contains(resident.id) {
                            chars.append(resident)
                        }
                    }
                    locationsChar.append(LocationChar(location: location, chars: chars))
                }
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
