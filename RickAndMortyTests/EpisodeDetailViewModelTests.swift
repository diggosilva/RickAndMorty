//
//  EpisodeDetailViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Diggo Silva on 01/10/25.
//

import XCTest
import Combine
@testable import RickAndMorty

final class EpisodeDetailViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    let episode = Episode(id: 1, name: "Pilot", airDate: "", episode: "", characters: [], url: "", created: "")
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testLoadCharactersInEpisodeSuccess() async {
        let mockService = MockService()
        let sut = EpisodeDetailViewModel(service: mockService, episode: episode)
        let expectation = XCTestExpectation(description: "State deveria ser .loaded")
        var receivedStates: [EpisodeDetailViewControllerState] = []
        
        sut.statePublisher.sink { state in
            receivedStates.append(state)
            if state == .loaded {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        sut.fetchCharactersInEpisode()
        await fulfillment(of: [expectation], timeout: 0.01)
        
        XCTAssertEqual(sut.numberOfRows(), 2)
        XCTAssertEqual(receivedStates.last, .loaded)
        
        let firstCharacter = sut.characterInEpisode(at: IndexPath(row: 0, section: 0)).name
        XCTAssertEqual(firstCharacter, "Rick Sanchez")
    }
    
    func testLoadCharactersInEpisodeFail() async {
        let mockService = MockService()
        mockService.isSuccess = false
        let sut = EpisodeDetailViewModel(service: mockService, episode: episode)
        let expectation = XCTestExpectation(description: "State deveria ser .error")
        var receivedState: [EpisodeDetailViewControllerState] = []
        
        sut.statePublisher.sink { state in
            receivedState.append(state)
            if state == .error {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        sut.fetchCharactersInEpisode()
        await fulfillment(of: [expectation], timeout: 0.01)
        
        XCTAssertEqual(sut.numberOfRows(), 0)
        XCTAssertEqual(receivedState, [.loading, .error])
    }
}
