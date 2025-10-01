//
//  EpisodesViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Diggo Silva on 30/09/25.
//

import XCTest
import Combine
@testable import RickAndMorty

final class EpisodesViewModelTest: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testIfLoadEpisodes() async {
        let mockService = MockService()
        let sut = EpisodesViewModel(service: mockService)
        let expectation = XCTestExpectation(description: "State deveria ser .loaded")
        var receivedStates: [EpisodesViewControllerStates] = []
        
        sut.statePublisher.sink { state in
            receivedStates.append(state)
            if state == .loaded {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        sut.fetchEpisodes()
        await fulfillment(of: [expectation], timeout: 0.01)
        
        XCTAssertEqual(sut.numberOfRows(), 2)
        XCTAssertEqual(receivedStates, [.loading, .loaded])
        
        let firstEpisode = sut.episode(at: IndexPath(row: 0, section: 0)).name
        XCTAssertEqual(firstEpisode, "Pilot")
    }
    
    func testIfLoadEpisodesFail() async {
        let mockService = MockService()
        mockService.isSuccess = false
        let sut = EpisodesViewModel(service: mockService)
        let expectation = XCTestExpectation(description: "State deveria der .error")
        var receivedStates: [EpisodesViewControllerStates] = []
        
        sut.statePublisher.sink { state in
            receivedStates.append(state)
            if state == .error {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        sut.fetchEpisodes()
        await fulfillment(of: [expectation], timeout: 0.01)
        
        XCTAssertEqual(sut.numberOfRows(), 0)
        XCTAssertEqual(receivedStates.last, .error)
    }
}
